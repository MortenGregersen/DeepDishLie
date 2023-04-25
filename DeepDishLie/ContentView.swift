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
            List(lieController.lieCases) { lieCase in
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
                            if lieController.statements[lieCase.id] != nil {
                                Text("Resolved 🎉🍕")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            } else {
                                Text("Unsolved \(randomThinkingEmoji)")
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
            .navigationTitle("2 Truths and a Lie")
            .navigationDestination(for: LieCase.self) { lieCase in
                SpeakerView(lieCase: lieCase)
            }
        }
    }

    private var randomThinkingEmoji: String {
        String("🤔🧐🕵🏽".randomElement()!)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let lieCase = LieController().lieCases[3]
        ContentView()
            .environmentObject(LieController.forPreview(statements: [lieCase.id: .one]))
    }
}
