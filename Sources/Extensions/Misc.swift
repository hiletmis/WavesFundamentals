//
//  File.swift
//  
//
//  Created by Hayrettin İletmiş on 3.03.2023.
//

import Foundation

public extension Encodable {

    subscript(key: String) -> Any? {
        return dictionary[key]
    }

    var data: Data? {
        return try? JSONEncoder().encode(self)
    }

    var dictionary: [String: Any] {
        guard let data = data else { return [:] }
        return (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] ?? [:]
    }
}
