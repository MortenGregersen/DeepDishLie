//
//  LieController.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 25/04/2023.
//

import SwiftUI

class LieController: ObservableObject {
    @Published private(set) var lieCases: [LieCase]

    var solvedLieCases: [LieCase] {
        lieCases.filter { $0.hasStatements && statements.keys.contains($0.id) }
    }

    var unsolvedLieCases: [LieCase] {
        lieCases.filter { $0.hasStatements && !statements.keys.contains($0.id) }
    }

    var unfinishedLieCases: [LieCase] {
        lieCases.filter { !$0.hasStatements }
    }

    @AppStorage("statements") private var statementsData = Data()
    private(set) var statements: [LieCase.ID: LieCase.Statement?] = [:]
    @Published var saveError: String?

    init() {
        let jsonData = try! Data(contentsOf: Bundle.main.url(forResource: "LieCases", withExtension: "json")!)
        self.lieCases = try! JSONDecoder().decode([LieCase].self, from: jsonData)
        do {
            self.statements = try JSONDecoder().decode([LieCase.ID: LieCase.Statement?].self, from: statementsData)
        } catch {
            self.statements = [:]
        }
    }
    
    @MainActor func fetchLieCases() async {
        do {
            let url = URL(string: "https://raw.githubusercontent.com/MortenGregersen/DeepDishLie/live-update/DeepDishLie/LieCases.json")!
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            self.lieCases = try JSONDecoder().decode([LieCase].self, from: data)
        } catch {
            print(error)
            // Do nothing
        }
    }

    @MainActor func select(statement: LieCase.Statement?, for lieCase: LieCase) {
        let oldStatement = statements[lieCase.id]
        statements[lieCase.id] = statement
        do {
            statementsData = try JSONEncoder().encode(statements)
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
    static func forPreview(numberOfLiesUnsolved: Int) -> LieController {
        let controller = LieController()
        let unsolvedLieCases = controller.unsolvedLieCases.filter { $0.speakerName != "Josh Holtz" }
        let numberOfLiesSolved = unsolvedLieCases.count - numberOfLiesUnsolved + 1
        controller.statements = unsolvedLieCases.shuffled().prefix(numberOfLiesSolved).map(\.id).reduce(into: [:]) { partialResult, id in
            partialResult[id] = LieCase.Statement.randomStatement
        }
        return controller
    }
}
