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
    
    func readFileIfExists(at url: URL) throws -> Data
    {
        if !AppFileStatusChecker().exists(file: url) {
            throw FileManagerError.fileNotFound(name: url.lastPathComponent)
        }
        return FileManager.default.contents(atPath: url.path)!
    }
    
    func writeFile(to url: URL, with data: Data) -> Bool
    {
        return FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
    }
    
    func deleteFile(at url: URL) -> Bool
    {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            return false
        }
        return true
    }
    
    
    func copyFile(at url: URL, to destinationURL: URL) -> Bool
    {
        try! FileManager.default.copyItem(at: url, to: destinationURL)
        return true
    }
    
    func createFolder(at url: URL) -> Bool {
        ((try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)) != nil)
    }
    
    func loadBundledContent(fromFileNamed name: String, withExtension fileExtension: String) throws -> Data {
        guard let url = Bundle.main.url(
            forResource: name,
            withExtension: fileExtension
        ) else {
            throw FileManagerError.fileNotFound(name: name)
        }
        return readFile(at: url)
    }
    
    enum FileManagerError: Error {
        case fileNotFound(name: String)
        case fileReadingFailed(name: String)
        case fileWritingFailed(name: String)
    }
}
