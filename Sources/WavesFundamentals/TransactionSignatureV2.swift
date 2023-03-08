//
//  TransactionSignature.swift
//  WavesSDKUI
//
//  Created by rprokofev on 23/05/2019.
//  Copyright © 2019 Waves. All rights reserved.
//

import Foundation
import WavesUtil
import Extensions

public extension TransactionSignatureV2 {
    
    enum Structure {

        public struct Reissue {
            
            public let fee: Int64
            public let chainId: Int
            public let senderPublicKey: String
            public let timestamp: Int64
            public let quantity: Int64
            public let assetId: String
            public let isReissuable: Bool
            
            public init(assetId: String, fee: Int64, chainId: Int, senderPublicKey: String, timestamp: Int64, quantity: Int64, isReissuable: Bool) {
                self.assetId = assetId
                self.fee = fee
                self.chainId = chainId
                self.senderPublicKey = senderPublicKey
                self.timestamp = timestamp
                self.quantity = quantity
                self.isReissuable = isReissuable
            }
        }
        
        public struct Issue {
            
            public let fee: Int64
            public let chainId: Int
            public let senderPublicKey: String
            public let timestamp: Int64
            public let quantity: Int64
            public let name: String
            public let description: String
            public let script: Base64?
            public let decimals: UInt8
            public let isReissuable: Bool
            
            public init(script: Base64?, fee: Int64, chainId: Int, senderPublicKey: String, timestamp: Int64, quantity: Int64, isReissuable: Bool, name: String, description: String, decimals: UInt8) {
                self.script = script
                self.fee = fee
                self.chainId = chainId
                self.senderPublicKey = senderPublicKey
                self.timestamp = timestamp
                self.quantity = quantity
                self.isReissuable = isReissuable
                self.name = name
                self.description = description
                self.decimals = decimals
            }
        }

        
        public struct Alias {
            public let alias: String
            public let fee: Int64
            public let chainId: Int
            public let senderPublicKey: String
            public let timestamp: Int64

            public init(alias: String, fee: Int64, chainId: Int, senderPublicKey: String, timestamp: Int64) {
                self.alias = alias
                self.fee = fee
                self.chainId = chainId
                self.senderPublicKey = senderPublicKey
                self.timestamp = timestamp
            }
        }
        
        public struct Lease {
            public let recipient: String
            public let amount: Int64
            public let fee: Int64
            public let chainId: Int
            public let senderPublicKey: String
            public let timestamp: Int64
            
            public init(recipient: String, amount: Int64, fee: Int64, chainId: Int, senderPublicKey: String, timestamp: Int64) {
                self.recipient = recipient
                self.amount = amount
                self.fee = fee
                self.chainId = chainId
                self.senderPublicKey = senderPublicKey
                self.timestamp = timestamp
            }
        }
        
        public struct Burn {
            public let assetID: String
            public let quantity: Int64
            public let fee: Int64
            public let chainId: Int
            public let senderPublicKey: String
            public let timestamp: Int64

            public init(assetID: String, quantity: Int64, fee: Int64, chainId: Int, senderPublicKey: String, timestamp: Int64) {
                self.assetID = assetID
                self.quantity = quantity
                self.fee = fee
                self.chainId = chainId
                self.senderPublicKey = senderPublicKey
                self.timestamp = timestamp
            }
        }
        
        public struct CancelLease {
            public let leaseId: String
            public let fee: Int64
            public let chainId: Int
            public let senderPublicKey: String
            public let timestamp: Int64

            public init(leaseId: String, fee: Int64, chainId: Int, senderPublicKey: String, timestamp: Int64) {
                self.leaseId = leaseId
                self.fee = fee
                self.chainId = chainId
                self.senderPublicKey = senderPublicKey
                self.timestamp = timestamp
            }
        }
                
        public struct Transfer {
            public let senderPublicKey: PublicKey
            public let recipient: String
            public let assetId: String
            public let amount: Int64
            public let fee: Int64
            public let attachment: String
            public let feeAssetID: String
            public let chainId: Int
            public let timestamp: Int64

            public init(senderPublicKey: String, recipient: String, assetId: String, amount: Int64, fee: Int64, attachment: String, feeAssetID: String, chainId: Int, timestamp: Int64) {
                self.senderPublicKey = senderPublicKey
                self.recipient = recipient
                self.assetId = assetId
                self.amount = amount
                self.fee = fee
                self.attachment = attachment
                self.feeAssetID = feeAssetID
                self.chainId = chainId
                self.timestamp = timestamp
            }
        }
         
        public struct InvokeScript {
            
            public struct Arg {
                public enum Value {
                    case bool(Bool) //boolean
                    case integer(Int64) // integer
                    case string(String) // string
                    case binary(String) // binary
                    case list([NodeService.Query.Transaction.InvokeScript.Arg])
                }
                
                public let value: Value

                public init(value: Value) {
                    self.value = value
                }
            }
            
            public struct Call {
                public let function: String
                public let args: [Arg]

                public init(function: String, args: [Arg]) {
                    self.function = function
                    self.args = args
                }
            }
            
            public struct Payment {
                public let amount: Int64
                public let assetId: String

                public init(amount: Int64, assetId: String) {
                    self.amount = amount
                    self.assetId = assetId
                }
            }
            
            public let senderPublicKey: PublicKey
            public let fee: Int64
            public let chainId: Int
            public let timestamp: Int64
            public let feeAssetId: String
            public let dApp: String
            public let call: Call?
            public let payment: [Payment]

            public init(senderPublicKey: PublicKey, fee: Int64, chainId: Int, timestamp: Int64, feeAssetId: String, dApp: String, call: Call?, payment: [Payment]) {
                self.senderPublicKey = senderPublicKey
                self.fee = fee
                self.chainId = chainId
                self.timestamp = timestamp
                self.feeAssetId = feeAssetId
                self.dApp = dApp
                self.call = call
                self.payment = payment
            }
        }
    }
}

public enum TransactionSignatureV2: TransactionSignatureProtocol {
    
    case createAlias(Structure.Alias)
    case startLease(Structure.Lease)
    case burn(Structure.Burn)
    case cancelLease(Structure.CancelLease)
    case transfer(Structure.Transfer)
    case reissue(Structure.Reissue)
    case issue(Structure.Issue)
    case invokeScript2(Structure.InvokeScript)
    
    public var version: Int {
        return 2
    }
    
    public var type: TransactionType {
        switch self {
        case .burn:
            return TransactionType.burn
            
        case .createAlias:
            return TransactionType.createAlias
            
        case .cancelLease:
            return TransactionType.cancelLease
            
        case .startLease:
            return TransactionType.createLease
            
        case .transfer:
            return TransactionType.transfer
        
        case .reissue:
            return TransactionType.reissue
            
        case .issue:
            return TransactionType.issue
            
        case .invokeScript2:
            return TransactionType.invokeScript
        }
    }
}

public extension TransactionSignatureV2 {
    
    var bytesStructure: Bytes {
        
        switch self {
        case .createAlias(let model):
            
            var alias: [UInt8] = toByteArray(Int8(self.version))
            alias += toByteArray(Int8(model.chainId))
            alias += model.alias.arrayWithSize()
            
            var signature: [UInt8] = []
            signature += toByteArray(self.typeByte)
            signature += toByteArray(Int8(self.version))
            signature += CryptoUtil.shared.base58decode(input: model.senderPublicKey) ?? []
            
            signature += alias.arrayWithSize()
            signature += toByteArray(model.fee)
            signature += toByteArray(model.timestamp)
            return signature
            
        case .startLease(let model):
            
            var recipient: [UInt8] = []
            if model.recipient.count <= WavesSDKConstants.aliasNameMaxLimitSymbols {
                recipient += toByteArray(Int8(self.version))
                recipient += toByteArray(Int8(model.chainId))
                recipient += model.recipient.arrayWithSize()
            } else {
                recipient += CryptoUtil.shared.base58decode(input: model.recipient) ?? []
            }
            
            var signature: [UInt8] = []
            signature += toByteArray(self.typeByte)
            signature += toByteArray(Int8(self.version))
            signature += [0]
            signature += CryptoUtil.shared.base58decode(input: model.senderPublicKey) ?? []
            
            signature += recipient
            signature += toByteArray(model.amount)
            signature += toByteArray(model.fee)
            signature += toByteArray(model.timestamp)
            return signature
            
        case .burn(let model):
            
            let assetId: [UInt8] = CryptoUtil.shared.base58decode(input: model.assetID) ?? []
            
            var signature: [UInt8] = []
            signature += toByteArray(self.typeByte)
            signature += toByteArray(Int8(self.version))
            signature += toByteArray(Int8(model.chainId))
            signature += CryptoUtil.shared.base58decode(input: model.senderPublicKey) ?? []
            signature += assetId
            signature += toByteArray(model.quantity)
            signature += toByteArray(model.fee)
            signature += toByteArray(model.timestamp)
            return signature
            
        case .cancelLease(let model):
            
            let leaseId: [UInt8] = CryptoUtil.shared.base58decode(input: model.leaseId) ?? []
            
            var signature: [UInt8] = []
            signature += toByteArray(self.typeByte)
            signature += toByteArray(Int8(self.version))
            signature += toByteArray(Int8(model.chainId))
            signature += CryptoUtil.shared.base58decode(input: model.senderPublicKey) ?? []
            signature += toByteArray(model.fee)
            signature += toByteArray(model.timestamp)
            signature += leaseId
            return signature
         
        case .transfer(let model):
            
            var recipient: [UInt8] = []
            if model.recipient.count <= WavesSDKConstants.aliasNameMaxLimitSymbols {
                recipient += toByteArray(Int8(self.version))
                recipient += toByteArray(Int8(model.chainId))
                recipient += model.recipient.arrayWithSize()
            } else {
                recipient += CryptoUtil.shared.base58decode(input: model.recipient) ?? []
            }
            
            let assetId = model.assetId.normalizeWavesAssetId
            let feeAssetID = model.feeAssetID.normalizeWavesAssetId
            
            var signature: [UInt8] = []
            signature += toByteArray(self.typeByte)
            signature += toByteArray(Int8(self.version))
            signature += (CryptoUtil.shared.base58decode(input: model.senderPublicKey) ?? [])
            signature += assetId.isEmpty ? [UInt8(0)] : ([UInt8(1)] + (CryptoUtil.shared.base58decode(input: assetId) ?? []))
            signature += feeAssetID.isEmpty ? [UInt8(0)] : ([UInt8(1)] + (CryptoUtil.shared.base58decode(input: feeAssetID) ?? []))
            signature += toByteArray(model.timestamp)
            signature += toByteArray(model.amount)
            signature += toByteArray(model.fee)
            signature += recipient
            signature += model.attachment.isEmpty == true ? [UInt8(0), UInt8(0)] : (CryptoUtil.shared.base58decode(input: model.attachment)?.arrayWithSize() ?? [])
            
            return signature
            
        case .reissue(let model):
            
            var signature: [UInt8] = []
            signature += toByteArray(self.typeByte)
            signature += toByteArray(Int8(self.version))
            signature += toByteArray(Int8(model.chainId))
            signature += CryptoUtil.shared.base58decode(input: model.senderPublicKey) ?? []
            signature += (CryptoUtil.shared.base58decode(input: model.assetId) ?? [])
            signature += toByteArray(model.quantity)
            signature += model.isReissuable == true ? [1] : [0]
            signature += toByteArray(model.fee)
            signature += toByteArray(model.timestamp)
            
            return signature
            
        case .issue(let model):
            
            var signature: [UInt8] = []
            signature += toByteArray(self.typeByte)
            signature += toByteArray(Int8(self.version))
            signature += toByteArray(Int8(model.chainId))
            signature += CryptoUtil.shared.base58decode(input: model.senderPublicKey) ?? []
            signature += model.name.arrayWithSize()
            signature += model.description.arrayWithSize()
            signature += toByteArray(model.quantity)
            signature += [model.decimals]
            signature += model.isReissuable == true ? [1] : [0]
            signature += toByteArray(model.fee)
            signature += toByteArray(model.timestamp)
            signature += (model.script?.isEmpty ?? true) ? [UInt8(0)] : ([UInt8(1)] + (CryptoUtil.shared.base64decode(input: model.script ?? "") ?? []).arrayWithSize())
            return signature
            
        case .invokeScript2(let model):
            var dApp: [UInt8] = []
            
            if model.dApp.count <= WavesSDKConstants.aliasNameMaxLimitSymbols {
                dApp += toByteArray(Int8(self.version))
                dApp += toByteArray(Int8(model.chainId))
                dApp += model.dApp.arrayWithSize()
            } else {
                dApp += CryptoUtil.shared.base58decode(input: model.dApp) ?? []
            }
            
            let feeAssetId = model.feeAssetId.normalizeWavesAssetId
                        
            var signature: [UInt8] = []
            signature += toByteArray(self.typeByte)
            signature += toByteArray(Int8(self.version))
            signature += toByteArray(Int8(model.chainId))
            signature += CryptoUtil.shared.base58decode(input: model.senderPublicKey) ?? []
            signature += dApp
            signature += model.callBytes
            signature += model.paymentBytes
            signature += toByteArray(model.fee)
            signature += feeAssetId.isEmpty ? [UInt8(0)] : ([UInt8(1)] + (CryptoUtil.shared.base58decode(input: feeAssetId) ?? []))
            signature += toByteArray(model.timestamp)
            return signature
        }
    }
}
  
private extension TransactionSignatureV2.Structure.InvokeScript.Call {
    
    var argsBytes: [UInt8] {
        var bytes: [UInt8] = []
        
        for arg in self.args {
            switch arg.value {
            case .binary(let value):
                
                bytes += [1] + (CryptoUtil.shared.base64decode(input: value) ?? []).arrayWithSize32()
                
            case .string(let value):
                
                bytes += [2] + value.arrayWithSize32()
                
            case .integer(let value):
                bytes += [0] + toByteArray(value)
                
            case .bool(let value):
                
                if value {
                    bytes += [6]
                } else {
                    bytes += [7]
                }
            case .list(let value):
                bytes += toByteArray(Int32(value.count))
            }
        }
        
        bytes = toByteArray(Int32(args.count)) + bytes
        
        return bytes
    }

}

private extension TransactionSignatureV2.Structure.InvokeScript {
    
    var callBytes: [UInt8] {
        if let call = self.call {
            return [1, 9, 1] + call.function.arrayWithSize32() + call.argsBytes
        } else {
            return [0]
        }
    }

    var paymentBytes: [UInt8] {
        var bytes: [UInt8] = []
        
        for paymentItem in self.payment {
            let amount = toByteArray(paymentItem.amount)
            
            let assetIdTrue = paymentItem.assetId.normalizeWavesAssetId
            
            let assetId = assetIdTrue.isEmpty ? [UInt8(0)] : ([UInt8(1)] + (CryptoUtil.shared.base58decode(input: assetIdTrue) ?? []))
            
            bytes += amount
            bytes += assetId
        }
        
        if bytes.count > 0 {
            bytes = toByteArray(Int16(self.payment.count)) + bytes.arrayWithSize()
        } else {
            bytes = toByteArray(Int16(self.payment.count))
        }
        
        return bytes
    }
}

