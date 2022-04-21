//
//  TwoDaysOnTwoDaysOffApp.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import SwiftUI
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool
    {
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool
    {
        RealmManager.shared.updateSchema(with: 7)
        UserSettings.registerUserSettings()
        UserDaysDataStorageManager.shared.updateStorage()
        UserColorThemeManager.shared.createStorageIfNeeded()
        
        return true
    }
}

@main
struct TwoDaysOnTwoDaysOffApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
