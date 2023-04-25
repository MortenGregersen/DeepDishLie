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
                Section {
                    LieCaseRow(lieCase: lieCase, statement: .one)
                    LieCaseRow(lieCase: lieCase, statement: .two)
                    LieCaseRow(lieCase: lieCase, statement: .three)
                } header: {
                    Text("2 Truths and a Lie")
                } footer: {
                    Text("Select the one you think is a lie 🤥")
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
        
        var body: some View {
            Button {
                lieController.select(statement: statement, for: lieCase)
            } label: {
                HStack {
                    Text(lieCase.getStatement(statement))
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
