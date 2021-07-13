//
//  AppDirectoryURLs.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import Foundation

enum AppDirectories : String
{
    case Documents = "Documents"
    case Temp = "tmp"
}

class AppDirectoryURLs {
    
    func documentsDirectoryURL() -> URL {
        
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func tempDirectoryURL() -> URL {
        return FileManager.default.temporaryDirectory
    }
    
    func getURL(for directory: AppDirectories) -> URL {
        switch directory
        {
        case .Documents:
            return documentsDirectoryURL()
            
        case .Temp:
            return tempDirectoryURL()
        }
    }
    
    func getFullPath(forFileName name: String, inDirectory directory: AppDirectories) -> URL {
        let url = getURL(for: directory).appendingPathComponent(name)
        
        if !AppFileStatusChecker().exists(file: url) {
            let _ = AppFileManager().writeFile(to: url, with: Data())
        }
        return url
    }
}
