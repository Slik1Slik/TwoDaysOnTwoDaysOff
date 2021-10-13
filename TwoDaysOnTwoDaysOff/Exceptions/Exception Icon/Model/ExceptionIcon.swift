//
//  ExceptionIcon.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 06.10.2021.
//

import UIKit
import RealmSwift

class ExceptionIcon: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var image: Data = Data()
    @objc dynamic var label: String = ""
    @objc dynamic var isWorking: Bool = false
    
    convenience init(id: Int, image: Data, label: String, isWorking: Bool) {
        self.init()
        
        self.id = id
        self.image = image
        self.label = label
        self.isWorking = isWorking
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case image
        case label
        case isWorking
    }
}

struct ExceptionIcons: Codable {
    var icons: [ExceptionIcon]
    
    enum CodingKeys: String, CodingKey {
        case icons
    }
}
