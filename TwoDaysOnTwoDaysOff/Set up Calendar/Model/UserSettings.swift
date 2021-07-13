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
    private enum SettingsKeys: String
    {
        case startDate
        case finalDate
        
        case countOfWorkingDays
        case countOfRestDays
        
        case wasApplicationEverLaunched
        case isCalendarFormed
        
        case restDayCellColor
        case workingDayCellColor
    }
    
    private static let userDefaults = UserDefaults.standard
    
    //@Defaults<Date>(key: "startDate") static var startDate
    
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
            let parsedDate = newValue.short()
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
            let parsedDate = newValue.short()
            let interval = parsedDate.timeIntervalSince1970
            userDefaults.set(interval, forKey: "finalDate")
        }
    }
    
    @Defaults<Int>(key: "countOfWorkingDays") static var countOfWorkingDays
    
    @Defaults<Int>(key: "countOfRestDays") static var countOfRestDays
    
    @Defaults<Bool>(key: "isCalendarFormed") static var isCalendarFormed
    
    @Defaults<Bool>(key: "wasApplicationEverLaunched") static var wasApplicationEverLaunched
    
    @Defaults<String>(key: "restDayCellColor") static var restDayCellColor
    
    @Defaults<String>(key: "workingDayCellColor") static var workingDayCellColor
    
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
        
        userDefaults.register(defaults: [SettingsKeys.wasApplicationEverLaunched.rawValue : true])
        userDefaults.register(defaults: [SettingsKeys.isCalendarFormed.rawValue : false])
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
