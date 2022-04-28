//
//  URL + Extensions.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 20.04.2022.
//

import Foundation

extension URL {
    var creationDate: Date {
        get {
            return (try? resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date().startOfDay
        }
        set {
            var resourceValues = URLResourceValues()
            resourceValues.creationDate = newValue
            try? setResourceValues(resourceValues)
        }
    }
}
