//
//  LieController.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 25/04/2023.
//

import SwiftUI

class LieController: ObservableObject {
    let lieCases: [LieCase] = [
        .init(speakerName: "Ariel Michaeli",
              speakerImage: "ariel_michaeli",
              statement1: "I play guitar. I've been playing for years. I am not great",
              statement2: "I dropped out of college",
              statement3: "I started my first (real) company when I was 16 or 17"),
        .init(speakerName: "Ben Proothi",
              speakerImage: "ben_proothi",
              statement1: "",
              statement2: "",
              statement3: ""),
        .init(speakerName: "Ben Scheirman",
              speakerImage: "ben_scheirman",
              statement1: "I have a titanium loom",
              statement2: "I can juggle 4 balls at once",
              statement3: "I live next door to a pro baseball player"),
        .init(speakerName: "Curtis Herbert",
              speakerImage: "curtis_herbert",
              statement1: "I have my pilot's license",
              statement2: "I am a surprisingly good dancer",
              statement3: "I have lived in Japan for 6 months"),
        .init(speakerName: "Danijela Vrzan",
              speakerImage: "danijela_vrzan",
              statement1: "I was a semi professional musician",
              statement2: "I have a green belt in karate",
              statement3: "I know how to lie"),
        .init(speakerName: "Ellen Shapiro",
              speakerImage: "ellen_shapiro",
              statement1: "I have 2 cats. They are both named after musicians",
              statement2: "I speak (at least at conversational level) 4 languages",
              statement3: "My first job when I was out in Los Angeles, was as an intern at the Ellen DeGeneres show, right after they went on the air"),
        .init(speakerName: "Emmanuel Crouvisier",
              speakerImage: "emmanuel_crouvisier",
              statement1: "I drive an electric car every day",
              statement2: "I've never had a speeding ticket",
              statement3: "I used to hate Apple entirely until the iPod came out"),
        .init(speakerName: "Josh Holtz",
              speakerImage: "josh_holtz",
              statement1: "The first programming language that I learned was Java",
              statement2: "I can do a backflip",
              statement3: "I can speak Japanese"),
        .init(speakerName: "Kai Dombrowski",
              speakerImage: "kai_dombrowski",
              statement1: "",
              statement2: "",
              statement3: ""),
        .init(speakerName: "Malin Sundberg",
              speakerImage: "malin_sundberg",
              statement1: "",
              statement2: "",
              statement3: ""),
        .init(speakerName: "Marc Aupont",
              speakerImage: "marc_aupont",
              statement1: "I am the oldest of 5",
              statement2: "I am a father of 3",
              statement3: "I've loved programming since childhood"),
        .init(speakerName: "Mikaela Caron",
              speakerImage: "mikaela_caron",
              statement1: "My first iPhone was an iPhone 4S",
              statement2: "I have an M1 Max MacBook Pro",
              statement3: "I have never shipped a Vapor project"),
        .init(speakerName: "Peter Steinberger",
              speakerImage: "peter_steinberger",
              statement1: "",
              statement2: "",
              statement3: ""),
        .init(speakerName: "Paul Hudson",
              speakerImage: "paul_hudson",
              statement1: "Before getting into app development, my specialism was women in ancient Greece",
              statement2: "Both my parents are church ministers",
              statement3: "I volunteer at my kid's school, teaching the girls there app development with Swift"),
        .init(speakerName: "Rudrank Riyam",
              speakerImage: "rudrank_riyam",
              statement1: "I sleep 10-12 hours every day",
              statement2: "I recently discovered that I love cross platform development",
              statement3: "Most of the code that I have written the past few weeks is by ChatGPT"),
        .init(speakerName: "Simon B. Støvring",
              speakerImage: "simon_storving",
              statement1: "I am volunteering as a scout leader",
              statement2: "I am volunteering at a local craft beer bar",
              statement3: "I am volunteering at a large music festival"),
        .init(speakerName: "Tunde Adegoroye",
              speakerImage: "tunde_adegoroye",
              statement1: "I used to play for a football academy when I was younger in high school",
              statement2: "I enjoy eating dry cereal",
              statement3: "I'm on TV on a TV show in the background, eating a McDonald's apple pie"),
        .init(speakerName: "Via Fairchild",
              speakerImage: "via_fairchild",
              statement1: "I own a unicycle",
              statement2: "I climbed and summitted Mount Fuji",
              statement3: "I have thalassophobia (fear of deep bodies of water)"),
        .init(speakerName: "Vince Davis",
              speakerImage: "vince_davis",
              statement1: "I have aspirations of being a pilot",
              statement2: "I love to take vacations in cold areas",
              statement3: "I have been to 10 countries"),
        .init(speakerName: "Vui Nguyen",
              speakerImage: "vui_nguyen",
              statement1: "I once caught a kokanee salmon",
              statement2: "I once caught a northern pike",
              statement3: "I once traveled to Beijing China to participate in an IoT hackathon"),
        .init(speakerName: "Zach Brass",
              speakerImage: "zach_brass",
              statement1: "",
              statement2: "",
              statement3: "")
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
    var hasStatements: Bool {
        !(statement1.isEmpty || statement2.isEmpty || statement3.isEmpty)
    }

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
