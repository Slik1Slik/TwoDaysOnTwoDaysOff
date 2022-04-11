//
//  Day.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import Foundation

struct Day: Codable
{
    var date: Date = Date()
    var isWorking: Bool = false
    var exception: Exception? = nil
    
    enum CodingKeys: CodingKey {
        case date
        case isWorking
    }
}

//@Persisted var date: Date = Date()
//@Persisted var isWorking: Bool = false
//@Persisted var exception: Exception? = nil
//
//convenience init(date: Date, isWorking: Bool, exception: Exception) {
//    self.init()
//
//    self.date = date
//    self.isWorking = isWorking
//    self.exception = exception
//}
