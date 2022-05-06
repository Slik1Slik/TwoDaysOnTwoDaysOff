//
//  AppFileManager.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import Foundation

class AppFileManager {
    
    static var shared: AppFileManager {
        get {
            return AppFileManager()
        }
    }
    
    func readFile(at url: URL) -> Data?
    {
        if !AppFileStatusChecker.shared.exists(file: url) {
            try? writeFile(to: url, with: Data())
        }
        return FileManager.default.contents(atPath: url.path)
    }
    
    func readFileIfExists(at url: URL) throws -> Data?
    {
        if !AppFileStatusChecker.shared.exists(file: url) {
            throw FileManagerError.fileNotFound
        }
        return FileManager.default.contents(atPath: url.path)
    }
    
    func writeFile(to url: URL, with data: Data) throws
    {
        if !FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil) {
            throw FileManagerError.failedToWriteFile
        }
    }
    
    func deleteFile(at url: URL) throws
    {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            throw FileManagerError.failedToRemoveFile
        }
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
            withExtension: fileExtension),
            let data = readFile(at: url)
        else {
            throw FileManagerError.fileNotFound
        }
        return data
    }
    
    enum FileManagerError: Error {
        case fileNotFound
        case failedToReadFile
        case failedToWriteFile
        case failedToRemoveFile
        case failedToLoadBundledContent
    }
}
