//
//  RealmManager.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 06.10.2021.
//

import Foundation
import RealmSwift

class RealmManager {
    class var shared: RealmManager {
        get {
            return RealmManager()
        }
    }
    
    func updateSchema(with newVersion: UInt64) {
        let config = Realm.Configuration(schemaVersion: newVersion) { migration, oldVersion in
            if oldVersion < 1 {
                
            }
        }
        Realm.Configuration.defaultConfiguration = config
        
        _ = try! Realm()
    }
}
