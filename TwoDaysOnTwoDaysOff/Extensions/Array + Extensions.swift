//
//  Array + Extensions.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import Foundation

extension Array where Element : Hashable
{
    var unique: [Element] {
        return Array(Set(self))
    }
}
