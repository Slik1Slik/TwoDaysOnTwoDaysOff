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
    @Persisted var from: Date = Date.init(timeIntervalSince1970: 0)
    @Persisted var to: Date = Date.init(timeIntervalSince1970: 0)
    @Persisted var name: String = ""
    @Persisted var details: String?
    @Persisted var icon: ExceptionIcon?
    @Persisted var isWorking: Bool = false
    
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
