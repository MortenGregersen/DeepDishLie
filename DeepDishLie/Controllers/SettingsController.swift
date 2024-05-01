//
//  SettingsController.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 01/05/2024.
//

import Foundation

@Observable
class SettingsController {
    var enableRandomConfetti: Bool { didSet {
        UserDefaults.standard.set(enableRandomConfetti, forKey: "enable-random-confetti")
        if enableRandomConfetti {
            startConfettiTimer()
        } else {
            stopConfettiTimer()
        }
    }}
    var randomConfettiIntensity: Double { didSet {
        UserDefaults.standard.set(randomConfettiIntensity, forKey: "random-confetti-intensity")
        if enableRandomConfetti {
            restartConfettiTimer()
            if randomConfettiIntensity == 5 {
                triggerConfetti()
                triggerConfetti()
                triggerConfetti()
            }
        }
    }}
    var useLocalTimezone: Bool { didSet { UserDefaults.standard.set(useLocalTimezone, forKey: "use-local-timezone") }}
    var use24hourClock: Bool { didSet { UserDefaults.standard.set(useLocalTimezone, forKey: "use-24-hour-clock") }}
    var openLinksInApp: Bool { didSet { UserDefaults.standard.set(openLinksInApp, forKey: "open-links-in-app") }}
    var useCelcius: Bool { didSet { UserDefaults.standard.set(useCelcius, forKey: "use-celcius") }}

    var confettiTrigger = 0
    private var timer: Timer?
    private var randomConfettiInterval: TimeInterval {
        let range: ClosedRange<TimeInterval> = switch randomConfettiIntensity {
        case 5:
            0...3
        case 4:
            5...15
        case 3:
            15...30
        case 2:
            30...45
        default:
            45...60
        }
        return TimeInterval.random(in: range)
    }

    init() {
        self.enableRandomConfetti = UserDefaults.standard.bool(forKey: "enable-random-confetti")
        self.randomConfettiIntensity = UserDefaults.standard.object(forKey: "random-confetti-intensity") as? Double ?? 2
        self.useLocalTimezone = UserDefaults.standard.bool(forKey: "use-local-timezone")
        self.use24hourClock = UserDefaults.standard.bool(forKey: "use-24-hour-clock")
        self.openLinksInApp = UserDefaults.standard.bool(forKey: "open-links-in-app")
        self.useCelcius = UserDefaults.standard.bool(forKey: "use-fahrenheit")

        if enableRandomConfetti {
            startConfettiTimer()
        }
    }

    func triggerConfetti() {
        confettiTrigger = Int.random(in: 0 ..< 42)
    }

    private func startConfettiTimer() {
        let timeInterval = randomConfettiInterval
        print(#function, timeInterval)
        timer = .scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: { [weak self] _ in
            self?.triggerConfetti()
            self?.startConfettiTimer()
        })
    }

    private func stopConfettiTimer() {
        timer?.invalidate()
    }

    private func restartConfettiTimer() {
        stopConfettiTimer()
        startConfettiTimer()
    }
}

extension SettingsController {
    static func forPreview() -> SettingsController {
        .init()
    }
}
