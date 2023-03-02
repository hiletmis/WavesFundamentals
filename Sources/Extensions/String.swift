//
//  File.swift
//  
//
//  Created by Hayrettin İletmiş on 2.03.2023.
//

import Foundation

public extension String {
    
    //TODO: Rename
    func arrayWithSize() -> [UInt8] {
        return Array(utf8).arrayWithSize()
    }
    
    //TODO: Rename
    func arrayWithSize32() -> [UInt8] {
        return Array(utf8).arrayWithSize32()
    }
    
    var normalizeWavesAssetId: String {
        if self == WavesSDKConstants.wavesAssetId {
            return ""
        } else {
            return self
        }
    }
    
    var normalizeToNullWavesAssetId: Any {
        
        let assetId = self.normalizeWavesAssetId
        
        if assetId.isEmpty {
            return NSNull()
        } else {
            return assetId
        }
    }
    
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    func trimmingLeadingWhitespace() -> String {
        let range = (self as NSString).range(of: "^\\s*", options: [.regularExpression])
        return (self as NSString).replacingCharacters(in: range, with: "")
    }
    
    func removeCharacters(from forbiddenChars: CharacterSet) -> String {
        let passed = unicodeScalars.filter { !forbiddenChars.contains($0) }
        return String(String.UnicodeScalarView(passed))
    }

    func removeCharacters(from: String) -> String {
        return removeCharacters(from: CharacterSet(charactersIn: from))
    }
    
    static func random(length: Int, letters: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") -> String {
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func toUInt() -> UInt? {
        let scanner = Scanner(string: self)
        var u: UInt64 = 0
        if scanner.scanUnsignedLongLong(&u)  && scanner.isAtEnd {
            return UInt(u)
        }
        return nil
    }
    
    var toBytes: [UInt8] {
        return [UInt8](self.utf8)
    }
}
