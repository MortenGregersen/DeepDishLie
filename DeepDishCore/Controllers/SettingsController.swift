//
//  SettingsController.swift
//  DeepDishCore
//
//  Created by Morten Bjerg Gregersen on 01/05/2024.
//

import Foundation

@Observable
public class SettingsController {
    public var enableRandomConfetti: Bool { didSet {
        UserDefaults.standard.set(enableRandomConfetti, forKey: "enable-random-confetti")
        if enableRandomConfetti {
            startConfettiTimer()
        } else {
            stopConfettiTimer()
        }
    }}
    public var randomConfettiIntensity: Double { didSet {
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
    public var useLocalTimezone: Bool { didSet { UserDefaults.standard.set(useLocalTimezone, forKey: "use-local-timezone") }}
    public var use24hourClock: Bool { didSet { UserDefaults.standard.set(useLocalTimezone, forKey: "use-24-hour-clock") }}
    public var openLinksInApp: Bool { didSet { UserDefaults.standard.set(openLinksInApp, forKey: "open-links-in-app") }}
    public var temperatureScale: TemperatureScale { didSet { UserDefaults.standard.set(temperatureScale.rawValue, forKey: "temperature-scale") }}

    public var confettiTrigger = 0
    private var timer: Timer?

    public init() {
        self.enableRandomConfetti = UserDefaults.standard.bool(forKey: "enable-random-confetti")
        self.randomConfettiIntensity = UserDefaults.standard.object(forKey: "random-confetti-intensity") as? Double ?? 2
        self.useLocalTimezone = UserDefaults.standard.bool(forKey: "use-local-timezone")
        self.use24hourClock = UserDefaults.standard.bool(forKey: "use-24-hour-clock")
        self.openLinksInApp = UserDefaults.standard.bool(forKey: "open-links-in-app")
        if UserDefaults.standard.bool(forKey: "use-celcius") {
            temperatureScale = .celsius
        } else if let temperatureScaleRawValue = UserDefaults.standard.string(forKey: "temperature-scale"),
                  let temperatureScale = TemperatureScale(rawValue: temperatureScaleRawValue) {
            self.temperatureScale = temperatureScale
        } else {
            temperatureScale = .fahrenheit
        }

        if enableRandomConfetti {
            startConfettiTimer()
        }
    }

    public func triggerConfetti() {
        confettiTrigger = Int.random(in: 0 ..< 42)
    }

    private func startConfettiTimer() {
        timer = .scheduledTimer(withTimeInterval: randomConfettiInterval(), repeats: false, block: { [weak self] _ in
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

    private func randomConfettiInterval() -> TimeInterval {
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
}

public extension SettingsController {
    static func forPreview() -> SettingsController {
        .init()
    }
}
