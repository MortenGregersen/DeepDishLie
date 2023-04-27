//
//  TruthsAndLiesView.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 25/04/2023.
//

import ConfettiSwiftUI
import SwiftUI

struct TruthsAndLiesView: View {
    @EnvironmentObject private var welcomeController: WelcomeController
    @EnvironmentObject private var lieController: LieController
    @Environment(\.colorScheme) private var colorScheme
    @State private var sortOrder = CaseSortOrder.abcAsc

    var body: some View {
        let sortComparator: (LieCase, LieCase) -> Bool = { case1, case2 in
            switch sortOrder {
            case .abcAsc: return case1.speakerName < case2.speakerName
            case .abcDesc: return case1.speakerName > case2.speakerName
            case .solvedAsc: return lieController.statements[case1.id] != nil && lieController.statements[case2.id] == nil
            case .solvedDesc: return lieController.statements[case1.id] == nil && lieController.statements[case2.id] != nil
            }
        }
        NavigationStack {
            List {
                Section {
                    ForEach(lieController.validLieCases.sorted(by: sortComparator)) { lieCase in
                        LieCaseRow(lieCase: lieCase)
                    }
                } header: {
                    VStack(spacing: 4) {
                        if lieController.solvedLieCasesCount == lieController.validLieCases.count {
                            HStack {
                                Text("🎉")
                                    .font(.system(size: 72))
                                    .scaleEffect(x: -1, y: 1)
                                Image("DeepDishLieLogo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 150)
                                Text("🎉")
                                    .font(.system(size: 72))
                            }
                            Text("Well done!")
                                .font(.largeTitle)
                            Text("You have found all of the lies")
                                .padding(.bottom, 8)
                        } else {
                            HStack {
                                Text("Progress")
                                Spacer()
                                Text("\(lieController.solvedLieCasesCount) out of \(lieController.validLieCases.count) solved \(headerEmoji)")
                            }

                            HStack(spacing: 0) {
                                ForEach(0 ..< lieController.validLieCases.count, id: \.self) { index in
                                    Text("🍕")
                                        .grayscale(index < lieController.solvedLieCasesCount ? 0.0 : 1.0)
                                }
                            }
                        }
                    }
                    .foregroundColor(.accentColor)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                }
            }
            .listStyle(.inset)
            .confettiCannon(counter: $lieController.confettiTrigger, num: 1, confettis: [.text("🍕"), .text("🤥"), .text("🍕"), .text("🤩")], confettiSize: 40, repetitions: 120, repetitionInterval: 0.08)
            .navigationTitle("2 Truths and a Lie")
            .toolbarBackground(Color("DarkAccentColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                Picker("Sort order", selection: $sortOrder) {
                    ForEach(CaseSortOrder.allCases) { sortOrder in
                        Label(sortOrder.title, systemImage: sortOrder.systemImage)
                            .labelStyle(.titleAndIcon)
                            .tag(sortOrder)
                    }
                }
            }
        }
        .blur(radius: welcomeController.isShowingWelcome ? 2.0 : 0.0)
        .overlay {
            if welcomeController.isShowingWelcome {
                WelcomeView()
            }
        }
        .onAppear {
            if !welcomeController.hasSeenWelcome || DeepDishLieApp.inDemoMode {
                welcomeController.isShowingWelcome = true
            }
        }
    }

    private enum CaseSortOrder: String, CaseIterable, Identifiable {
        case abcAsc
        case abcDesc
        case solvedAsc
        case solvedDesc

        var id: String { rawValue }

        var title: String {
            switch self {
            case .abcAsc, .abcDesc: return "ABC"
            case .solvedAsc, .solvedDesc: return "Solved"
            }
        }

        var systemImage: String {
            switch self {
            case .abcAsc, .solvedAsc: return "arrow.down"
            case .abcDesc, .solvedDesc: return "arrow.up"
            }
        }
    }

    private var headerEmoji: String {
        let solvedLieCasesCount = lieController.solvedLieCasesCount
        if solvedLieCasesCount == 0 { return "🙃" }
        else if solvedLieCasesCount < 5 { return "🙂" }
        else if solvedLieCasesCount < 10 { return "😉" }
        else if solvedLieCasesCount < 15 { return "😃" }
        else if solvedLieCasesCount < lieController.validLieCases.count { return "😆" }
        else { return "🤩" }
    }

    private struct LieCaseRow: View {
        let lieCase: LieCase
        @EnvironmentObject private var lieController: LieController
        private var isExpanded: Binding<Bool> {
            .init {
                lieController.expandedLieCases.contains(lieCase.id)
            } set: {
                if $0 { lieController.expandedLieCases.insert(lieCase.id) }
                else { lieController.expandedLieCases.remove(lieCase.id) }
            }
        }

        var body: some View {
            DisclosureGroup(isExpanded: isExpanded) {
                LieCaseStatementRow(lieCase: lieCase, statement: .one)
                LieCaseStatementRow(lieCase: lieCase, statement: .two)
                LieCaseStatementRow(lieCase: lieCase, statement: .three)
            } label: {
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
                            Text("**Lie:** ") + Text("\"\(lieCase.getStatement(statement))\"")
                        }
                    }
                }
            }
        }
    }

    private struct LieCaseStatementRow: View {
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

struct TruthsAndLiesView_Previews: PreviewProvider {
    static var previews: some View {
        TruthsAndLiesView()
            .environmentObject(WelcomeController.forPreview(hasSeenWelcome: true))
            .environmentObject(LieController.forPreview(numberOfLiesSolved: 11))
    }
}
