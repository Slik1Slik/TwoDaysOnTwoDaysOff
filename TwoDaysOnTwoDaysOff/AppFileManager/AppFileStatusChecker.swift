//
//  AppFileStatusChecker.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import Foundation

class AppFileStatusChecker {
    
    static func isReadable(file at: URL) -> Bool {
        return FileManager.default.isReadableFile(atPath: at.path)
    }
    
    static func isWritable(file at: URL) -> Bool {
        return FileManager.default.isReadableFile(atPath: at.path)
    }
    
    static func exists(file at: URL) -> Bool {
        return FileManager.default.fileExists(atPath: at.path)
    }
}
