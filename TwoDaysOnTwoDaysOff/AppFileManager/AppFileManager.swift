//
//  AppFileManager.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import Foundation

class AppFileManager {
    
    func readFile(at url: URL) -> Data
    {
        if !AppFileStatusChecker().exists(file: url) {
            let _ = writeFile(to: url, with: Data())
        }
        return FileManager.default.contents(atPath: url.path)!
    }
    
    func writeFile(to url: URL, with data: Data) -> Bool
    {
        return FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
    }
    
    func deleteFile(at url: URL) -> Bool
    {
        try! FileManager.default.removeItem(at: url)
        return true
    }
    
    
    func copyFile(at url: URL, to destinationURL: URL) -> Bool
    {
        try! FileManager.default.copyItem(at: url, to: destinationURL)
        return true
    }
}
