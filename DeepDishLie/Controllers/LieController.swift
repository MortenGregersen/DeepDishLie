//
//  LieController.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 25/04/2023.
//

import SwiftUI

class LieController: ObservableObject {
    @Published private var lieCases: [LieCase]
    var validLieCases: [LieCase] { lieCases.filter(\.hasStatements) }
    var solvedLieCasesCount: Int { validLieCases.filter { statements.keys.contains($0.id) }.count }
    @Published var expandedLieCases = Set<LieCase.ID>()
    @AppStorage("statements") private var statementsData = Data()
    private(set) var statements: [LieCase.ID: LieCase.Statement?] = [:]
    @Published var saveError: String?
    @Published var confettiTrigger = 0
    private static let cachedJsonFilename = "LieCases.json"

    init() {
        if let lieCases = Self.loadCachedLieCases() {
            self.lieCases = lieCases
        } else {
            let jsonData = try! Data(contentsOf: Bundle.main.url(forResource: "LieCases", withExtension: "json")!)
            self.lieCases = try! JSONDecoder().decode([LieCase].self, from: jsonData)
        }
        do {
            if !DeepDishLieApp.inDemoMode {
                self.statements = try JSONDecoder().decode([LieCase.ID: LieCase.Statement?].self, from: statementsData)
            }
        } catch {}
    }

    private static func loadCachedLieCases() -> [LieCase]? {
        guard let cacheFolderURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first,
              let cachedJsonData = try? Data(contentsOf: cacheFolderURL.appending(component: cachedJsonFilename)) else { return nil }
        return try? JSONDecoder().decode([LieCase].self, from: cachedJsonData)
    }

    @MainActor func fetchLieCases() async {
        do {
            let url = URL(string: "https://raw.githubusercontent.com/MortenGregersen/DeepDishLie/main/DeepDishLie/LieCases.json")!
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            lieCases = try JSONDecoder().decode([LieCase].self, from: data)
            guard let cacheFolderURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
            try data.write(to: cacheFolderURL.appending(component: Self.cachedJsonFilename))
        } catch {
            // Fail silently
        }
    }

    @MainActor func select(statement: LieCase.Statement, for lieCase: LieCase) {
        let oldStatement = statements[lieCase.id]
        if oldStatement == statement {
            statements[lieCase.id] = nil
            confettiTrigger = 0
        } else {
            statements[lieCase.id] = statement
            _ = withAnimation {
                expandedLieCases.remove(lieCase.id)
            }
            if statements.keys.count == validLieCases.count {
                confettiTrigger = 1
            }
        }
        do {
            let statementsData = try JSONEncoder().encode(statements)
            withAnimation {
                self.statementsData = statementsData
            }
        } catch {
            saveError = "Could not save you guess. (\(error.localizedDescription))"
            statements[lieCase.id] = oldStatement
        }
    }
}

struct LieCase: Codable, Hashable, Identifiable {
    var id: String { speakerImage }
    let speakerName: String
    let speakerImage: String
    let statement1: String
    let statement2: String
    let statement3: String
    var hasStatements: Bool {
        !(statement1.isEmpty || statement2.isEmpty || statement3.isEmpty)
    }

    func getStatement(_ statement: Statement) -> String {
        switch statement {
        case .one: return statement1
        case .two: return statement2
        case .three: return statement3
        }
    }

    enum Statement: String, Codable {
        case one
        case two
        case three

        fileprivate static var randomStatement: Statement {
            [Self.one, Self.two, Self.three].randomElement()!
        }
    }
}

extension LieController {
    static func forPreview(numberOfLiesSolved: Int) -> LieController {
        let controller = LieController()
        controller.statements = controller.validLieCases.shuffled().prefix(numberOfLiesSolved).map(\.id).reduce(into: [:]) { partialResult, id in
            partialResult[id] = LieCase.Statement.randomStatement
        }
        return controller
    }
}
