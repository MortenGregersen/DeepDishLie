//
//  CountdownView.swift
//  DeepDishAppCore
//
//  Created by Morten Bjerg Gregersen on 09/02/2025.
//

import SwiftUI

public struct CountdownView: View {
    let eventDate: Date
    @State private var timeRemaining: String?
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let titleFont: Font = OperatingSystem.current == .watchOS ? .headline : .title
    private let timeFont: Font = OperatingSystem.current == .watchOS ? .title2 : .largeTitle

    public init(eventDate: Date) {
        self.eventDate = eventDate
    }

    public var body: some View {
        if OperatingSystem.current == .watchOS {
            realBody
                .padding(.top, 16)
                .ignoresSafeArea(.container, edges: .top)
        } else {
            NavigationStack {
                realBody
            }
        }
    }

    private var realBody: some View {
        ScrollView {
            VStack(spacing: 0) {
                FlickeringPizzaView(repeating: true)
                    .ifOS(.watchOS) { $0.frame(width: 100) }
                    .ifOS(.macOS) { $0.frame(maxHeight: 600) }
                    .ifOS(.tvOS) { $0.frame(maxHeight: 700) }
                if let timeRemaining {
                    Text("The conference will start in:")
                        .font(titleFont)
                    Text(timeRemaining)
                        .font(timeFont)
                        .monospacedDigit()
                        .contentTransition(.numericText(countsDown: true))
                        .animation(.default, value: timeRemaining)
                        .frame(maxWidth: .infinity)
                        .padding(.top, OperatingSystem.current == .watchOS ? 8 : 16)
                } else {
                    Text("The conference has started!")
                        .font(timeFont)
                }
            }
            .padding(.horizontal)
        }
        .onAppear(perform: updateCountdown)
        .onReceive(timer) { _ in updateCountdown() }
        .fontWeight(.bold)
        .multilineTextAlignment(.center)
        .foregroundStyle(.white)
        .background(Color.splashBackground)
    }

    private func updateCountdown() {
        let now = Date()
        let remaining = eventDate.timeIntervalSince(now)
        if remaining > 0 {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = remaining > 86_400 ? [.day, .hour, .minute, .second] : [.hour, .minute, .second]
            formatter.unitsStyle = .brief
            timeRemaining = formatter.string(from: remaining) ?? "Calculating..."
        } else {
            timeRemaining = nil
        }
    }
}

#Preview {
    CountdownView(eventDate: Date().addingTimeInterval(84.4 * 86_400))
}
