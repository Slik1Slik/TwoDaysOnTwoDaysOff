//
//  JSONManager.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import Foundation

class JSONManager {
    
    class var shared: JSONManager {
        get {
            return JSONManager()
        }
    }
    
    func read<T>(for type: T.Type, from url: URL) throws -> T where T: Decodable
    {
        let decoder = JSONDecoder()
        let formatter = DateConstants.dateFormatter
        
        guard let data = try? AppFileManager.shared.readFileIfExists(at: url) else {
            throw AppFileManager.FileManagerError.failedToReadFile
        }
        
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        do {
             return try decoder.decode(T.self, from: data)
        } catch {
            throw JSONManagerError.fileDecodingFailed
        }
    }
    
    func write<T>(_ object: T, to url: URL) throws where T: Encodable
    {
        let encoder = JSONEncoder()
        let formatter = DateConstants.dateFormatter
        
        encoder.dateEncodingStrategy = .formatted(formatter)
        
        guard let data = try? encoder.encode(object) else {
            throw AppFileManager.FileManagerError.failedToReadFile
        }
        
        do {
            try AppFileManager.shared.writeFile(to: url, with: data)
        } catch let error {
            throw error
        }
    }
    
    func read<T>(for type: T.Type, from data: Data) throws -> T where T: Decodable
    {
        let decoder = JSONDecoder()
        let formatter = DateConstants.dateFormatter
        
        decoder.dateDecodingStrategy = .formatted(formatter)
        decoder.dataDecodingStrategy = .base64
        
        do {
             return try decoder.decode(T.self, from: data)
        } catch {
            throw JSONManagerError.fileDecodingFailed
        }
    }
    
    enum JSONManagerError: Error {
        case fileDecodingFailed
        case fileEncodingFailed
    }
}
