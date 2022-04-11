//
//  Exception.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 16.12.2021.
//

import Foundation
import RealmSwift

class Exception: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId = .generate()
    @Persisted var from: Date = Date()
    @Persisted var to: Date = Date()
    @Persisted var name: String = ""
    @Persisted var details: String = ""
    @Persisted var isWorking: Bool = false
    
    convenience init(from: Date, to: Date, name: String, details: String, isWorking: Bool) {
        self.init()
        
        self.from = from
        self.to = to
        self.name = name
        self.details = details
        self.isWorking = isWorking
    }
}
