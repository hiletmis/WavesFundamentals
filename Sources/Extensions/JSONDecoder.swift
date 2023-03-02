//
//  File.swift
//  
//
//  Created by Hayrettin İletmiş on 2.03.2023.
//

import Foundation

public extension JSONDecoder {

    static func decode<Model: Decodable>(json fileName: String) -> Model? {
        let decoder = JSONDecoder()
        guard let path = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            return nil
        }
        guard let data = try? Data(contentsOf: path) else {
            return nil
        }

        return try? decoder.decode(Model.self, from: data)
    }
}
