//
//  SettingsController.swift
//  DeepDishCore
//
//  Created by Morten Bjerg Gregersen on 01/05/2024.
//

import Defaults
import Foundation

@Observable @MainActor
public class SettingsController {
    public var enableRandomConfetti: Bool { didSet {
        Defaults[.enableRandomConfetti] = enableRandomConfetti
        if enableRandomConfetti {
            triggerConfetti()
            startConfettiTimer()
        } else {
            stopConfettiTimer()
        }
    }}
    public var randomConfettiIntensity: Double { didSet {
        Defaults[.randomConfettiIntensity] = randomConfettiIntensity
        if enableRandomConfetti {
            restartConfettiTimer()
            if randomConfettiIntensity == 5 {
                triggerConfetti()
                triggerConfetti()
                triggerConfetti()
            }
        }
    }}
    public var useLocalTimezone: Bool { didSet { Defaults[.useLocalTimezone] = useLocalTimezone }}
    public var use24hourClock: Bool { didSet { Defaults[.useLocalTimezone] = use24hourClock }}
    public var openLinksInApp: Bool { didSet { Defaults[.openLinksInApp] = openLinksInApp }}
    public var temperatureScale: TemperatureScale { didSet { Defaults[.temperatureScale] = temperatureScale }}
    public var menuBarExtraShown: Bool { didSet { Defaults[.menuBarExtraShown] = menuBarExtraShown }}

    public var confettiTrigger = false
    private var timer: Timer?

    public init() {
        self.enableRandomConfetti = Defaults[.enableRandomConfetti]
        self.randomConfettiIntensity = Defaults[.randomConfettiIntensity]
        self.useLocalTimezone = Defaults[.useLocalTimezone]
        self.use24hourClock = Defaults[.use24hourClock]
        self.openLinksInApp = Defaults[.openLinksInApp]
        self.temperatureScale = Defaults[.temperatureScale]
        self.menuBarExtraShown = Defaults[.menuBarExtraShown]
        if enableRandomConfetti {
            startConfettiTimer()
        }
    }

    public func triggerConfetti() {
        confettiTrigger.toggle()
    }

    private func startConfettiTimer() {
        timer = .scheduledTimer(withTimeInterval: randomConfettiInterval(), repeats: false, block: { [weak self] _ in
            DispatchQueue.main.async {
                self?.triggerConfetti()
                self?.startConfettiTimer()
            }
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

extension Defaults.Keys {
    @MainActor static let enableRandomConfetti = Key<Bool>("enable-random-confetti", default: UserDefaults.standard.bool(forKey: "enable-random-confetti"), suite: UserDefaults.appGroup)
    @MainActor static let randomConfettiIntensity = Key<Double>("random-confetti-intensity", default: UserDefaults.standard.object(forKey: "random-confetti-intensity") as? Double ?? 2, suite: UserDefaults.appGroup)
    @MainActor static let useLocalTimezone = Key<Bool>("use-local-timezone", default: UserDefaults.standard.bool(forKey: "use-local-timezone"), suite: UserDefaults.appGroup)
    @MainActor static let use24hourClock = Key<Bool>("use-24-hour-clock", default: UserDefaults.standard.bool(forKey: "use-24-hour-clock"), suite: UserDefaults.appGroup)
    @MainActor static let openLinksInApp = Key<Bool>("open-links-in-app", default: UserDefaults.standard.bool(forKey: "open-links-in-app"), suite: UserDefaults.appGroup)
    @MainActor static let temperatureScale = Key<TemperatureScale>("temperature-scale", default: .fahrenheit, suite: UserDefaults.appGroup)
    @MainActor static let menuBarExtraShown = Key<Bool>("menu-bar-extra-shown", default: true, suite: UserDefaults.appGroup)
}

public extension SettingsController {
    static func forPreview() -> SettingsController {
        .init()
    }
}
