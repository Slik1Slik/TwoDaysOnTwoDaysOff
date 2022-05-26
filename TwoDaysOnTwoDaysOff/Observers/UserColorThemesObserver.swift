//
//  UserColorThemesObserver.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 25.04.2022.
//

import Combine
import UIKit

class UserColorThemesObserver: ObservableObject {
    
    var onAnyChange: () -> () = { }
    var onThemeAdded: () -> () = { }
    var onThemeUpdated: () -> () = { }
    var onThemeRemoved: () -> () = { }
    
    
    func startObserving() {
        NotificationCenter.default
            .addObserver(forName: UserColorThemeNotifications.themeDidBecomeAdded, object: nil, queue: .main) { [weak self] _ in
                self?.onThemeAdded()
                self?.onAnyChange()
            }
        NotificationCenter.default
            .addObserver(forName: UserColorThemeNotifications.themeDidUpdate, object: nil, queue: .main) { [weak self] _ in
                self?.onThemeUpdated()
                self?.onAnyChange()
            }
        NotificationCenter.default
            .addObserver(forName: UserColorThemeNotifications.themeDidBecomeRemove, object: nil, queue: .main) { [weak self] _ in
                self?.onThemeRemoved()
                self?.onAnyChange()
            }
    }
    
    func stopObserving() {
        NotificationCenter.default
            .removeObserver(self, name: UserColorThemeNotifications.themeDidBecomeAdded, object: nil)
        NotificationCenter.default
            .removeObserver(self, name: UserColorThemeNotifications.themeDidUpdate, object: nil)
        NotificationCenter.default
            .removeObserver(self, name: UserColorThemeNotifications.themeDidBecomeRemove, object: nil)
    }
}


