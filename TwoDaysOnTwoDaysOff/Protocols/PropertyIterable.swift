//
//  PropertyIterable.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 12.04.2022.
//

import Foundation

protocol PropertyIterable {
    static func iterate() -> [String : Any]
}

extension PropertyIterable {
    static func iterate() -> [String : Any] {
        var result: [String: Any] = [:]
        
        let mirror = Mirror(reflecting: self)
        
        for (property, value) in mirror.children {
            guard let property = property else {
                continue
            }
            result[property] = value
        }
        
        return result
    }
}
