//
//  GiveawayJoinFormView.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 29/04/2024.
//

import SwiftUI

struct GiveawayJoinFormView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var joining = false
    @State private var joiningError: Error?
    @FocusState private var nameInFocus
    @Environment(\.dismiss) private var dismiss
    @Environment(GiveawayController.self) private var giveawayController

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name, prompt: Text("John Appleseed"))
                        .focused($nameInFocus)
                } header: {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text("Required")
                            .font(.caption2)
                            .foregroundStyle(.accent)
                    }
                }
                Section {
                    TextField("", text: $email)
                } header: {
                    HStack {
                        Text("Email")
                        Spacer()
                        Text("Optional")
                            .font(.caption2)
                    }
                } footer: {
                    Text("Enter email address to receive updates about future releases of [AppDab](https://AppDab.app). **This is not required to win.**")
                }
                if let joiningError {
                    Section {
                        Text(joiningError.localizedDescription)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Join Giveaway")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.accentColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .disabled(joining)
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        joinGiveaway()
                    } label: {
                        Text("Join")
                    }
                    .disabled(joining || name.isEmpty)
                }
            }
            .onAppear {
                nameInFocus = true
            }
        }
    }
    
    private func joinGiveaway() {
        Task {
            joining = true
            do {
                try await giveawayController.joinTheGiveaway(name: name, email: email)
                dismiss()
            } catch {
                joiningError = error
            }
            joining = false
        }
    }
}

#Preview {
    GiveawayJoinFormView()
        .environment(GiveawayController())
}
