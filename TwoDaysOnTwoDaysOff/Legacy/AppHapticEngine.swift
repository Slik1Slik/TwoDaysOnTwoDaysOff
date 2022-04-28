//
//  AppHapticEngine.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 03.04.2022.
//

import Foundation
import CoreHaptics

class AppHapticEngine {
    private var supportsHaptics: Bool = false
    private var engine: CHHapticEngine!
    private var isValid: Bool = false
    
    class var shared: AppHapticEngine {
        get {
            AppHapticEngine()
        }
    }
    
    func play(_ haptic: HapticType) {
        switch haptic {
        case .singleTap:
            let hapticDict = [
                CHHapticPattern.Key.pattern: [
                    [CHHapticPattern.Key.event: [
                        CHHapticPattern.Key.eventType: CHHapticEvent.EventType.hapticTransient,
                        CHHapticPattern.Key.time: CHHapticTimeImmediate,
                        CHHapticPattern.Key.eventDuration: 1.0]
                    ]
                ]
            ]
            play(from: hapticDict)
        case .fromDictionary(let dictionary):
            play(from: dictionary)
        }
    }
    
    private func play(from dictionary: [CHHapticPattern.Key : Any]) {
        guard let pattern = try? CHHapticPattern(dictionary: dictionary) else { return }
        guard let player = try? engine.makePlayer(with: pattern) else { return }
        engine.notifyWhenPlayersFinished { error in
            return .stopEngine
        }
        do {
            try engine.start()
            try player.start(atTime: 0)
        } catch {
            return
        }
    }
    
    init() {
        checkHapticCapability()
        createHapticEngine()
        resetEngineIfNeeded()
    }
    
    private func checkHapticCapability() {
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
        supportsHaptics = hapticCapability.supportsHaptics
    }
    
    private func createHapticEngine() {
        do {
            engine = try CHHapticEngine()
        } catch {
            isValid = false
        }
    }
    
    private func resetEngineIfNeeded() {
        engine.resetHandler = { [self] in
            do {
                try self.engine.start()
                self.isValid = true
            } catch {
                self.isValid = false
            }
        }
    }
}

enum HapticType {
    case singleTap
    case fromDictionary([CHHapticPattern.Key : Any])
}
