//
//  AppDirectoryURLs.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import Foundation

enum AppDirectories : String
{
    case documents = "Documents"
    case temp = "tmp"
}

class AppDirectoryURLs {
    
    func documentsDirectoryURL() -> URL {
        
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }
    
    func tempDirectoryURL() -> URL {
        return FileManager.default.temporaryDirectory
    }
    
    func getURL(for directory: AppDirectories) -> URL {
        switch directory
        {
        case .documents:
            return documentsDirectoryURL()
            
        case .temp:
            return tempDirectoryURL()
        }
    }
    
    func getFullPath(forFileName name: String, inDirectory directory: AppDirectories) -> URL {
        return getURL(for: directory).appendingPathComponent(name)
    }
}
