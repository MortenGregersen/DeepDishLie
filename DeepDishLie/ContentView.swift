//
//  ContentView.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 25/04/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var lieController: LieController

    var body: some View {
        NavigationStack {
            List {
                Section("Unsolved lies 🤔") {
                    ForEach(lieController.unsolvedLieCases) { lieCase in
                        LieCaseRow(lieCase: lieCase)
                    }
                }
                Section("Solved lies 🎉") {
                    ForEach(lieController.solvedLieCases) { lieCase in
                        LieCaseRow(lieCase: lieCase)
                    }
                }
                Section("Unfinished lies 😢") {
                    ForEach(lieController.unfinishedLieCases) { lieCase in
                        LieCaseRow(lieCase: lieCase)
                    }
                }
            }
            .navigationTitle("2 Truths and a Lie")
            .navigationDestination(for: LieCase.self) { lieCase in
                SpeakerView(lieCase: lieCase)
            }
        }
    }

    struct LieCaseRow: View {
        let lieCase: LieCase
        @EnvironmentObject private var lieController: LieController

        var body: some View {
            NavigationLink(value: lieCase) {
                HStack {
                    Image(lieCase.speakerImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                        .clipShape(Circle())
                    VStack(alignment: .leading) {
                        Text(lieCase.speakerName)
                            .font(.headline)
                            .foregroundColor(.accentColor)
                        if let statement = lieController.statements[lieCase.id] as? LieCase.Statement {
                            Text("\"\(lieCase.getStatement(statement))\"")
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let lieCase = LieController().lieCases[3]
        ContentView()
            .environmentObject(LieController.forPreview(statements: [lieCase.id: .one]))
    }
}
