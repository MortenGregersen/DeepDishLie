//
//  SpeakerView.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 25/04/2023.
//

import SwiftUI

struct SpeakerView: View {
    let lieCase: LieCase

    var body: some View {
        List {
            if lieCase.hasStatements {
                Section("Statement 1") {
                    LieCaseRow(lieCase: lieCase, statement: .one)
                }
                Section("Statement 2") {
                    LieCaseRow(lieCase: lieCase, statement: .two)
                }
                Section("Statement 3") {
                    LieCaseRow(lieCase: lieCase, statement: .three)
                }
            } else {
                Text("No truths or lies has been given.\nWaiting for the episode of [Slices](https://podcasts.apple.com/ca/podcast/slices-the-deep-dish-swift-podcast/id1670026071) to be released.")
            }
        }
        .navigationTitle(lieCase.speakerName)
        .toolbar {
            Image(lieCase.speakerImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 36)
                .clipShape(Circle())
                
        }
    }

    struct LieCaseRow: View {
        let lieCase: LieCase
        let statement: LieCase.Statement
        @EnvironmentObject private var lieController: LieController
        private var text: String {
            switch statement {
            case .one: return lieCase.statement1
            case .two: return lieCase.statement2
            case .three: return lieCase.statement3
            }
        }

        var body: some View {
            Button {
                lieController.select(statement: statement, for: lieCase)
            } label: {
                HStack {
                    Text(text)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: lieController.statements[lieCase.id] == statement ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                }
            }
        }
    }
}

struct SpeakerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            let lieCase = LieController().lieCases[1]
            SpeakerView(lieCase: lieCase)
                .environmentObject(LieController.forPreview(statements: [lieCase.id: .two]))
        }
    }
}
