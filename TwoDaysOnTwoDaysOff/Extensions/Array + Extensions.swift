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
    
    var uniqueWithSavingOriginalOrder: [Element]
    {
        var resultArray = [Element]()
        
        for index in 0..<self.count
        {
            if !resultArray.contains(self[index])
            {
                resultArray.append(self[index])
            }
        }
        
        return resultArray
    }
}

extension Array where Element : Hashable
{
    func countOf(_ element: Element) -> Int
    {
        return self.filter{
            $0 == element
        }.count
    }
}

extension Array
{
    func reversed(_ reversed: Bool) -> [Element]
    {
        if reversed {
            return self.reversed()
        } else {
            return self
        }
    }
}
