//
//  InvokeScriptTransactionNode.swift
//  Alamofire
//
//  Created by rprokofev on 07/05/2019.
//

import Foundation

extension NodeService.DTO {

    /**
     Invoke script transaction is a transaction that invokes functions of the dApp script.
     dApp contains compiled functions  developed with [Waves Ride IDE]({https://ide.wavesplatform.com/)
     You can invoke one of them by name with some arguments.
     */
    public struct InvokeScriptTransaction: Codable {
        /**
         Call the function from dApp (address or alias) with typed arguments
         */
        public struct Call: Codable {
            /**
             Arguments for the function call
             */
            public struct Args: Codable {
                @frozen public enum Value {
                    case bool(Bool)
                    case integer(Int64)
                    case string(String)
                    case binary(String)
                    case list([Args])
                }

                public let type: String
                public let value: Value

                public init(type: String, value: Value) {
                    self.type = type
                    self.value = value
                }
            }

            /**
             Function unique name
             */
            public let function: String

            /**
             List of arguments
             */
            public let args: [Args]

            public init(function: String, args: [Args]) {
                self.function = function
                self.args = args
            }
        }

        /**
         Payment for function of dApp. Now it works with only one payment.
         */
        public struct Payment: Codable {
            /**
             Amount in satoshi
             */
            public let amount: Amount
            /**
             Asset Id in Waves blockchain
             */
            public let assetId: String?

            public init(amount: Amount, assetId: String?) {
                self.amount = amount
                self.assetId = assetId
            }
            
            public func toAmountInt() -> Int64 {
                guard let data = amount.data else { return 0 }
                let stringInt = String.init(data: data, encoding: String.Encoding.utf8)
                return Int64.init(stringInt ?? "") ?? 0
            }
            
            public enum Amount: Codable {
                case integer(Int64)

                public init(from decoder: Decoder) throws {
                    let container = try decoder.singleValueContainer()
                    do {
                        self = .integer(try container.decode(Int64.self))
                    } catch {
                        let y = try container.decode(String.self)
                        self = .integer(Int64(y) ?? 0)
                    }
                }

                public func encode(to encoder: Encoder) throws {
                    var container = encoder.singleValueContainer()
                    switch self {
                    case .integer(let x):
                        try container.encode(x)
                    }
                }
            }
        }

        public let type: Int
        public let id: String?
        public let chainId: UInt8?
        public let sender: String?
        public let senderPublicKey: String
        public let fee: Int64?

        public let timestamp: Date?
        public let proofs: [String]?
        public let version: Int?

        public let height: Int64?

        /**
         Asset id instead Waves for transaction commission withdrawal
         */
        public let feeAssetId: String?

        /**
         dApp – address or alias of contract with function on RIDE language
         */
        public let dApp: String

        /**
         Function name in dApp with array of arguments
         */
        public let call: Call?

        /**
         Payments for function of dApp. Now it works with only one payment.
         */
        public let payment: [Payment]

        public let applicationStatus: String?
    
        public init(
            type: Int,
            id: String,
            chainId: UInt8?,
            sender: String,
            senderPublicKey: String,
            fee: Int64,
            timestamp: Date,
            proofs: [String]?,
            version: Int,
            height: Int64?,
            feeAssetId: String?,
            dApp: String,
            call: Call?,
            payment: [Payment],
            applicationStatus: String?) {
            self.type = type
            self.id = id
            self.chainId = chainId
            self.sender = sender
            self.senderPublicKey = senderPublicKey
            self.fee = fee
            self.timestamp = timestamp
            self.proofs = proofs
            self.version = version
            self.height = height
            self.feeAssetId = feeAssetId
            self.dApp = dApp
            self.call = call
            self.payment = payment
            self.applicationStatus = applicationStatus
        }
    }
}

extension NodeService.DTO.InvokeScriptTransaction.Call.Args {
    enum CodingKeys: String, CodingKey {
        case type
        case value
    }

    enum ValueKey: String {
        case boolean
        case integer
        case string
        case binary
        case list
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let value = try container.decodeIfPresent(String.self, forKey: .type) {
            type = value
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath,
                                                                    debugDescription: "Not found type"))
        }

        if let type = ValueKey(rawValue: self.type) {
            switch type {
            case .boolean:
                value = .bool(try container.decode(Bool.self, forKey: .value))
            case .integer:
                do {
                    value = .integer(try container.decode(Int64.self, forKey: .value))
                } catch {
                    let y = try container.decode(String.self, forKey: .value)
                    value = .integer(Int64(y) ?? 0)
                }
            case .string:
                value = .string(try container.decode(String.self, forKey: .value))
            case .binary:
                value = .binary(try container.decode(String.self, forKey: .value))
            case .list:
                value = .list(try container.decode([NodeService.DTO.InvokeScriptTransaction.Call.Args].self, forKey: .value))
            }
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath,
                                                                    debugDescription: "Not found value"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        do {
            switch value {
            case let .bool(value):
                try container.encode(value, forKey: .value)
                try container.encode(ValueKey.boolean.rawValue, forKey: .type)

            case let .integer(value):
                try container.encode(value, forKey: .value)
                try container.encode(ValueKey.integer.rawValue, forKey: .type)

            case let .string(value):
                try container.encode(value, forKey: .value)
                try container.encode(ValueKey.string.rawValue, forKey: .type)

            case let .binary(value):
                try container.encode(value, forKey: .value)
                try container.encode(ValueKey.binary.rawValue, forKey: .type)
            case let .list(value):
                try container.encode(value, forKey: .value)
                try container.encode(ValueKey.list.rawValue, forKey: .type)
                
            }
        } catch _ {
            throw NSError(domain: "Decoder Invalid Data ValueAA", code: 0, userInfo: nil)
        }
    }
}
