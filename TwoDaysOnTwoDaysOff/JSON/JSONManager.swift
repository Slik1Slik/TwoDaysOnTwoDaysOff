//
//  JSONManager.swift
//  TwoDaysOnTwoDaysOff
//
//  Created by Slik on 28.06.2021.
//

import Foundation

class JSONManager {
    
    static func read<T>(for type: T.Type, from url: URL) -> T? where T: Decodable
    {
        let decoder = JSONDecoder()
        let formatter = DateConstants.dateFormatter
        var data = Data()
        
        do {
            try data = Data(contentsOf: url)
        } catch {
            print(error)
        }
        
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        let result: T? = try? decoder.decode(T.self, from: data)
        
        return result
    }
    
    static func write<T>(_ object: T, to url: URL) -> Bool where T: Encodable
    {
        let encoder = JSONEncoder()
        let formatter = DateConstants.dateFormatter
        
        encoder.dateEncodingStrategy = .formatted(formatter)
        
        guard let data = try? encoder.encode(object) else {return false}
        
        return AppFileManager().writeFile(to: url, with: data)
    }
    
    static func read<T>(for type: T.Type, from data: Data) -> T? where T: Decodable
    {
        let decoder = JSONDecoder()
        let formatter = DateConstants.dateFormatter
        
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        let result: T? = try? decoder.decode(T.self, from: data)
        
        return result
    }
}
