//
//  File.swift
//  
//
//  Created by Hayrettin İletmiş on 2.03.2023.
//

import Foundation

public func toByteArray<T>(_ value: T) -> [UInt8] {
    var value = value
    return (withUnsafeBytes(of: &value) { Array($0) }).reversed()
}


public extension Array where Element == UInt8 {

    //TODO: Rename
    func arrayWithSize() -> [UInt8] {
        let b: [UInt8] = self
        return toByteArray(Int16(Swift.min(Int(Int16.max), b.count))) + b
    }
    
    //TODO: Rename
    func arrayWithSize32() -> [UInt8] {
        let b: [UInt8] = self
        return toByteArray(Int32(b.count)) + b
    }
}
