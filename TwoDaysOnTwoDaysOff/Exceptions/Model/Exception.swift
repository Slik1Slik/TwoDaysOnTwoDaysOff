//
//  Exception.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import Foundation
import RealmSwift

class Exception: Object
{
    @objc dynamic var from: Date = Date.init(timeIntervalSince1970: 0)
    @objc dynamic var to: Date = Date.init(timeIntervalSince1970: 0)
    @objc dynamic var name: String = ""
    @objc dynamic var details: String?
    @objc dynamic var icon: ExceptionIcon?
    @objc dynamic var isWorking: Bool = false
    
    convenience init(from: Date, to: Date, name: String, details: String?, icon: ExceptionIcon?, isWorking: Bool)
    {
        self.init()
        
        self.from = from
        self.to = to
        self.name = name.trimmingCharacters(in: [" "]).capitalized
        self.details = details
        self.icon = icon
        self.isWorking = isWorking
    }
}
