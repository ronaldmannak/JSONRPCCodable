//
//  JSONRPCArrayDecoder.swift
//  JSONRPCCodable
//
//  Created by Ronald "Danger" Mannak on 3/23/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//

import Foundation

public class JSONRPCArrayDecoder {
    fileprivate var array: [Decodable]
    fileprivate var counter = 0
    
    /// If true, ArrayDecoder will automatically try to decode hex Strings and Ints
    public var decodeHexStrings: Bool = true

    public init(array: [Decodable]) { // OR: can we pass it as "/"param1/", /"param2/"" etc?
        self.array = array
    }
}

public extension JSONRPCArrayDecoder {

    public static func decode<T: Decodable>(_ type: T.Type, from: [Decodable]) throws -> T {
        return try JSONRPCArrayDecoder(array: from).decode(T.self)
    }
    
}

// Decoding
public extension JSONRPCArrayDecoder {
    // What happens is that T.init(decoder) on line 27 called decode(FirstTypeOfStruct), decode(SecondTypeOfStruct), etc. So we read the next item in the array and convert it to Type and return it!
    
    public func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        
        let item = try readNext()
        if let item = item as? T {
            // If item is correct type, return item
            return item
        }
        
        switch type {        
        case is String.Type:
            if let string = item as? String {
                return string as! T
            } else {
                return "\(item)" as! T
            }
            // It would be great if we could use generics here, something like...
//        case is Int.Type, is Int8.Type, is Int16.Type, is Int32.Type, is Int64.Type, is UInt.Type, is UInt8.Type, is UInt16.Type, is UInt32.Type, is UInt64.Type:
//            if let item = item as? String {
//                if decodeHexStrings == true, item.has0xPrefix == true, let value = item.hexToNumeric(type: T) {
//                 // Received a hex string
//                    return value as! T
//                } else if let value = type(item) {
//                    // Received value embedded in a string
//                    return value as! T
//                }
//            }
//            throw Error.typeNotConformingToJSONRPCCodable(type)
        case is Int.Type:
            if let item = item as? String {
                if decodeHexStrings == true, item.has0xPrefix == true, let value = item.hexToInt {
                    // Received a hex string
                    return value as! T
                } else if let value = Int(item) {
                    // Received value embedded in a string
                    return value as! T
                }
            }
            throw Error.typeNotConformingToJSONRPCCodable(type)
        case is Int8.Type:
            if let item = item as? String {
                if decodeHexStrings == true, item.has0xPrefix == true, let value = item.hexToInt8 {
                    return value as! T
                } else if let value = Int8(item) {
                    return value as! T
                }
            }
            throw Error.typeNotConformingToJSONRPCCodable(type)
        case is Int16.Type:
            if let item = item as? String {
                if decodeHexStrings == true, item.has0xPrefix == true, let value = item.hexToInt16 {
                    return value as! T
                } else if let value = Int16(item) {
                    return value as! T
                }
            }
            throw Error.typeNotConformingToJSONRPCCodable(type)
        case is Int32.Type:
            if let item = item as? String {
                if decodeHexStrings == true, item.has0xPrefix == true, let value = item.hexToInt32 {
                    return value as! T
                } else if let value = Int32(item) {
                    return value as! T
                }
            }
            throw Error.typeNotConformingToJSONRPCCodable(type)
        case is Int64.Type:
            if let item = item as? String {
                if decodeHexStrings == true, item.has0xPrefix == true, let value = item.hexToInt64 {
                    return value as! T
                } else if let value = Int64(item) {
                    return value as! T
                }
            }
            throw Error.typeNotConformingToJSONRPCCodable(type)
        case is UInt.Type:
            if let item = item as? String {
                if decodeHexStrings == true, item.has0xPrefix == true, let value = item.hexToUInt {
                    // Received a hex string
                    return value as! T
                } else if let value = UInt(item) {
                    // Received value embedded in a string
                    return value as! T
                }
            }
            throw Error.typeNotConformingToJSONRPCCodable(type)
        case is UInt8.Type:
            if let item = item as? String {
                if decodeHexStrings == true, item.has0xPrefix == true, let value = item.hexToUInt8 {
                    return value as! T
                } else if let value = UInt8(item) {
                    return value as! T
                }
            }
            throw Error.typeNotConformingToJSONRPCCodable(type)
        case is UInt16.Type:
            if let item = item as? String {
                if decodeHexStrings == true, item.has0xPrefix == true, let value = item.hexToUInt16 {
                    return value as! T
                } else if let value = UInt16(item) {
                    return value as! T
                }
            }
            throw Error.typeNotConformingToJSONRPCCodable(type)
        case is UInt32.Type:
            if let item = item as? String {
                if decodeHexStrings == true, item.has0xPrefix == true, let value = item.hexToUInt32 {
                    return value as! T
                } else if let value = UInt32(item) {
                    return value as! T
                }
            }
            throw Error.typeNotConformingToJSONRPCCodable(type)
        case is UInt64.Type:
            if let item = item as? String {
                if decodeHexStrings == true, item.has0xPrefix == true, let value = item.hexToUInt64 {
                    return value as! T
                } else if let value = UInt64(item) {
                    return value as! T
                }
            }
            throw Error.typeNotConformingToJSONRPCCodable(type)
        case is Data.Type:
            // Unformatted data in Ethereum is encoded in a hex string
            if let string = item as? String, string.has0xPrefix, let data = Data(hexString: string) {
                return data as! T
            }
            throw Error.typeNotConformingToJSONRPCCodable(type)
        default:
            return try T(from: self)
        }
    }
    
    private func readNext() throws -> Any {
        guard array.count > 0 && array.count > counter else {
            throw Error.prematureEndOfData
        }
        let item: Any = array[counter]
        counter = counter + 1
        return item
    }
    
    public func readCurrent() -> Any {        
        return array[counter - 1]
    }
}

/// Containers
extension JSONRPCArrayDecoder: Decoder {
    public var codingPath: [CodingKey] { return [] }
    
    public var userInfo: [CodingUserInfoKey : Any] { return [:] }
    
    public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        return KeyedDecodingContainer(KeyedContainer<Key>(decoder: self))
    }
    
    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return UnkeyedContainer(decoder: self)
    }
    
    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        return UnkeyedContainer(decoder: self)
    }
    
    private struct KeyedContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
        var decoder: JSONRPCArrayDecoder
        
        var codingPath: [CodingKey] { return [] }
        
        var allKeys: [Key] { return [] }
        
        func contains(_ key: Key) -> Bool {
            return true
        }
        
        func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
            return try decoder.decode(T.self)
        }
        
        func decodeNil(forKey key: Key) throws -> Bool {
            return true
        }
        
        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            return try decoder.container(keyedBy: type)
        }
        
        func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
            return try decoder.unkeyedContainer()
        }
        
        func superDecoder() throws -> Decoder {
            return decoder
        }
        
        func superDecoder(forKey key: Key) throws -> Decoder {
            return decoder
        }
    }
    
    private struct UnkeyedContainer: UnkeyedDecodingContainer, SingleValueDecodingContainer {
        var decoder: JSONRPCArrayDecoder
        
        var codingPath: [CodingKey] { return [] }
        
        var count: Int? { return nil }
        
        var currentIndex: Int { return 0 }
        
        var isAtEnd: Bool { return false }
        
        func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
            return try decoder.decode(type)
        }
        
        func decodeNil() -> Bool {
            return true
        }
        
        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            return try decoder.container(keyedBy: type)
        }
        
        func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
            return self
        }
        
        func superDecoder() throws -> Decoder {
            return decoder
        }
    }
}

/// Errors
public extension JSONRPCArrayDecoder {
    
    /// All errors which `ArrayDecoder` itself can throw.
    enum Error: Swift.Error {
        /// The decoder hit the end of the data while the values it was decoding expected more.
        case prematureEndOfData
        
        /// Attempted to decode a type which is `Decodable`, but not `BinaryDecodable`. (We
        /// require `BinaryDecodable` because `BinaryDecoder` doesn't support full keyed
        /// coding functionality.)
        case typeNotConformingToJSONRPCCodable(Decodable.Type)
    }
}
