//
//  SpeakerView.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 25/04/2023.
//

import SwiftUI

struct SpeakerView: View {
    let lieCase: LieCase
    @Environment(\.presentationMode) var presentationMode

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
                    Text("Choose the false statement once you have talked to the person and found out which of the three statements is untrue 🤥")
                }
            } else {
                Text("No truths or lies has been given.\nWaiting for the episode of [Slices](https://podcasts.apple.com/ca/podcast/slices-the-deep-dish-swift-podcast/id1670026071) to be released.")
            }
        }
        .navigationTitle(lieCase.speakerName)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Label("2 Truths and a Lie", systemImage: "chevron.left")
                        .fontWeight(.bold)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(lieCase.speakerImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 36)
                    .clipShape(Circle())
                    .navigationBarBackButtonHidden(true)
            }
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
            let lieController = LieController.forPreview(numberOfLiesUnsolved: 0)
            let lieCase = lieController.solvedLieCases.first!
            SpeakerView(lieCase: lieCase)
                .environmentObject(lieController)
        }
    }
}
