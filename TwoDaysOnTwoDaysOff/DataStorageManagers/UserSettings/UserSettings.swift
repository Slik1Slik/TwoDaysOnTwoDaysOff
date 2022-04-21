//
//  UserSettings.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import UIKit

@propertyWrapper
struct Defaults<T> {
    let key: String
    
    var storage: UserDefaults = .standard
    
    var wrappedValue: T?
    {
        get {
            storage.value(forKey: key) as? T
        }
        
        set{
            storage.set(newValue, forKey: key)
        }
    }
}

final class UserSettings
{
    
    private static let userDefaults = UserDefaults.standard
    
    //@Defaults<Date>(key: "startDate") static var startDate
    
    static var schedule: Schedule
    {
        get
        {
            let startDateInterval = userDefaults.value(forKey: "startDate") as! Double
            let finalDateInterval = userDefaults.value(forKey: "finalDate") as! Double
            
            let countOfWorkingDays = userDefaults.value(forKey: "countOfWorkingDays") as! Int
            let countOfRestDays = userDefaults.value(forKey: "countOfRestDays") as! Int
            
            return Schedule(startDate: Date.init(timeIntervalSince1970: startDateInterval),
                             finalDate: Date.init(timeIntervalSince1970: finalDateInterval),
                             countOfWorkingDays: countOfWorkingDays,
                             countOfRestDays: countOfRestDays)
        }
        
        set
        {
            let dateFromValue = newValue.startDate.short.timeIntervalSince1970
            let dateToValue = newValue.finalDate.short.timeIntervalSince1970
            
            userDefaults.set(dateFromValue, forKey: "startDate")
            userDefaults.set(dateToValue, forKey: "finalDate")
            
            userDefaults.set(newValue.countOfWorkingDays, forKey: "countOfWorkingDays")
            userDefaults.set(newValue.countOfRestDays, forKey: "countOfRestDays")
        }
    }
    
    static var startDate: Date
    {
        get
        {
            let interval = userDefaults.value(forKey: "startDate") as! Double
            let date = Date.init(timeIntervalSince1970: interval)
            return date
        }
        set
        {
            let parsedDate = newValue.short
            let interval = parsedDate.timeIntervalSince1970
            userDefaults.set(interval, forKey: "startDate")
        }
    }
    
    static var finalDate: Date
    {
        get
        {
            let interval = userDefaults.value(forKey: "finalDate") as! Double
            let date = Date.init(timeIntervalSince1970: interval)
            return date
        }
        set
        {
            let parsedDate = newValue.short
            let interval = parsedDate.timeIntervalSince1970
            userDefaults.set(interval, forKey: "finalDate")
        }
    }
    
    static var colorPaletteToken: ColorPaletteToken
    {
        get
        {
            let tokenString = userDefaults.value(forKey: "colorPaletteToken") as! String
            
            switch tokenString {
            case ColorPaletteToken.user.rawValue: return ColorPaletteToken.user
            case ColorPaletteToken.monochrome.rawValue: return ColorPaletteToken.monochrome
            default: return ColorPaletteToken.user
            }
        }
        set
        {
            userDefaults.set(newValue.rawValue, forKey: "colorPaletteToken")
        }
    }
    
    @Defaults<Int>(key: "countOfWorkingDays") static var countOfWorkingDays
    
    @Defaults<Int>(key: "countOfRestDays") static var countOfRestDays
    
    @Defaults<Bool>(key: "isCalendarFormed") static var isCalendarFormed
    
    @Defaults<Bool>(key: "wasApplicationEverLaunched") static var wasApplicationEverLaunched
    
    @Defaults<Int>(key: "countOfAppLaunches") static var countOfAppLaunches
    
    @Defaults<String>(key: "restDayCellColor") static var restDayCellColor
    
    @Defaults<String>(key: "workingDayCellColor") static var workingDayCellColor
    
    @Defaults<String>(key: "colorThemeID") static var colorThemeID
    
    static func registerUserSettings()
    {
        let red = UIColor.systemRed.cgColor.components
        let gray = UIColor.systemGray.cgColor.components
        
        userDefaults.register(defaults: [SettingsKeys.restDayCellColor.rawValue : red as Any])
        userDefaults.register(defaults: [SettingsKeys.workingDayCellColor.rawValue : gray as Any])
        
        userDefaults.register(defaults: [SettingsKeys.startDate.rawValue : 1615939200.0])
        userDefaults.register(defaults: [SettingsKeys.finalDate.rawValue : 1647475200.0])
        
        userDefaults.register(defaults: [SettingsKeys.countOfWorkingDays.rawValue : 3])
        userDefaults.register(defaults: [SettingsKeys.countOfRestDays.rawValue : 3])
        
        userDefaults.register(defaults: [SettingsKeys.colorPaletteToken.rawValue : ""])
        userDefaults.register(defaults: [SettingsKeys.colorThemeID.rawValue : "Монохром"])
        
        userDefaults.register(defaults: [SettingsKeys.wasApplicationEverLaunched.rawValue : true])
        userDefaults.register(defaults: [SettingsKeys.isCalendarFormed.rawValue : false])
        
        userDefaults.register(defaults: [SettingsKeys.countOfAppLaunches.rawValue : 1])
    }
    
    private enum SettingsKeys: String
    {
        case startDate
        case finalDate
        
        case countOfWorkingDays
        case countOfRestDays
        
        case wasApplicationEverLaunched
        case countOfAppLaunches
        case isCalendarFormed
        
        case restDayCellColor
        case workingDayCellColor
        
        case colorPaletteToken
        case colorThemeID
    }
}

enum UserSettingsErrors: Error
{
    case UnableToGetStartDate
    case UnableToSetStartDate
    
    case UnableToGetFinalDate
    case UnableToSetFinalDate
    
    case UnableToGetCountOfWorkingDays
    case UnableToSetCountOfWorkingDays
    
    case UnableToGetCountOfRestDays
    case UnableToSetCountOfRestDays
}