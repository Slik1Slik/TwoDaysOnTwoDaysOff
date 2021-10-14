//
//  ExceptionIcon.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 06.10.2021.
//

import UIKit
import RealmSwift

class ExceptionIcon: Object, Codable {
    @Persisted var id: Int = -1
    @Persisted var image: Data = UIImage(named: "exceptionIconPlaceholder")!.pngData()!
    @Persisted var label: String = ""
    @Persisted var isWorking: Bool = false
    
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

extension ExceptionIcon {
    var isPlaceholder: Bool {
        return self.id < 0
    }
}

struct ExceptionIcons: Codable {
    var icons: [ExceptionIcon]
    
    enum CodingKeys: String, CodingKey {
        case icons
    }
}
