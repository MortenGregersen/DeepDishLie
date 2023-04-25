//
//  LieController.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 25/04/2023.
//

import SwiftUI

class LieController: ObservableObject {
    let lieCases: [LieCase] = [
        .init(speakerName: "Curtis Herbert",
              speakerImage: "curtis_herbert",
              statement1: "I have my pilot's license",
              statement2: "I am a surprisingly good dancer",
              statement3: "I have lived in Japan for 6 months"),
        .init(speakerName: "Kai Dombrowski",
              speakerImage: "kai_dombrowski",
              statement1: "",
              statement2: "",
              statement3: ""),
        .init(speakerName: "Ariel Michaeli", speakerImage: "ariel_michaeli", statement1: "", statement2: "", statement3: ""),
        .init(speakerName: "Malin Sundberg", speakerImage: "malin_sundberg", statement1: "", statement2: "", statement3: ""),
        .init(speakerName: "Emmanuel Crouvisier", speakerImage: "emmanuel_crouvisier", statement1: "I drive an electric car every day", statement2: "I've never had a speeding ticket", statement3: "I used to hate Apple entirely until the iPod came out"),
        .init(speakerName: "Rudrank Riyam", speakerImage: "rudrank_riyam", statement1: "", statement2: "", statement3: ""),
        .init(speakerName: "Peter Steinberger", speakerImage: "peter_steinberger", statement1: "", statement2: "", statement3: ""),
        .init(speakerName: "Ben Scheirman", speakerImage: "ben_scheirman", statement1: "", statement2: "", statement3: ""),
        .init(speakerName: "Tunde Adegoroye", speakerImage: "tunde_adegoroye", statement1: "", statement2: "", statement3: ""),
        .init(speakerName: "Ellen Shapiro", speakerImage: "ellen_shapiro", statement1: "", statement2: "", statement3: ""),
        .init(speakerName: "Danijela Vrzan", speakerImage: "danijela_vrzan", statement1: "", statement2: "", statement3: ""),
        .init(speakerName: "Mikaela Caron", speakerImage: "mikaela_caron", statement1: "", statement2: "", statement3: ""),
        .init(speakerName: "Marc Aupont", speakerImage: "marc_aupont", statement1: "", statement2: "", statement3: ""),
        .init(speakerName: "Ben Proothi", speakerImage: "ben_proothi", statement1: "", statement2: "", statement3: ""),
        .init(speakerName: "Via Fairchild", speakerImage: "via_fairchild", statement1: "", statement2: "", statement3: ""),
        .init(speakerName: "Paul Hudson", speakerImage: "paul_hudson", statement1: "", statement2: "", statement3: ""),
        .init(speakerName: "Vince Davis", speakerImage: "vince_davis", statement1: "", statement2: "", statement3: ""),
        .init(speakerName: "Vui Nguyen", speakerImage: "vui_nguyen", statement1: "", statement2: "", statement3: ""),
        .init(speakerName: "Simon B. Støvring", speakerImage: "simon_storving", statement1: "", statement2: "", statement3: ""),
        .init(speakerName: "Zach Brass", speakerImage: "zach_brass", statement1: "", statement2: "", statement3: "")
    ].sorted(using: KeyPathComparator(\.speakerName))
    private(set) var statements: [LieCase.ID: LieCase.Statement?] = [:]
    @Published var saveError: String?

    @AppStorage("statements") private var statementsData = Data()

    init() {
        do {
            self.statements = try JSONDecoder().decode([LieCase.ID: LieCase.Statement?].self, from: statementsData)
        } catch {
            self.statements = [:]
        }
    }

    func select(statement: LieCase.Statement?, for lieCase: LieCase) {
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

struct LieCase: Hashable, Identifiable {
    var id: String { speakerImage }
    let speakerName: String
    let speakerImage: String
    let statement1: String
    let statement2: String
    let statement3: String

    enum Statement: String, Codable {
        case one
        case two
        case three
    }
}

extension LieController {
    static func forPreview(statements: [LieCase.ID: LieCase.Statement?]) -> LieController {
        let lieController = LieController()
        lieController.statements = statements
        return lieController
    }
}
