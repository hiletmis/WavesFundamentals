//
//  Interface.swift
//  WavesSDKUI
//
//  Created by rprokofev on 23/05/2019.
//  Copyright © 2019 Waves. All rights reserved.
//

import Foundation
import WavesUtil

public protocol SignatureProtocol {
    
    var bytesStructure: Bytes { get }
    
    func signature(privateKey: PrivateKey) -> Bytes?
    
    func signature(privateKey: PrivateKey) -> String?
    
    var id: String { get }
}

public extension SignatureProtocol {
    
    func signature(seed: Seed) -> Bytes? {
        return CryptoUtil.shared.signBytes(bytes: bytesStructure, seed: seed)
    }
    
    func signature(seed: Seed) -> String? {
        guard let bytes: Bytes = signature(seed: seed) else { return nil }
        return CryptoUtil.shared.base58encode(input: bytes)
    }
    
    func signature(privateKey: PrivateKey) -> Bytes? {
        return CryptoUtil.shared.signBytes(bytes: bytesStructure, privateKey: privateKey)
    }
    
    func signature(privateKey: PrivateKey) -> String? {
        guard let bytes: Bytes = signature(privateKey: privateKey) else { return nil }
        return CryptoUtil.shared.base58encode(input: bytes)
    }
    
    var id: String {
        return CryptoUtil.shared.base58encode(input: CryptoUtil.shared.blake2b256(input: bytesStructure)) ?? ""
    }
}
