//
//  JSONRPCArrayEncoder.swift
//  JSONRPCCodable
//
//  Created by Ronald "Danger" Mannak on 3/13/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//

import Foundation

/**
 */
public class JSONRPCArrayEncoder {
    fileprivate (set) var array = [String]()  //  Current limitation: encode can only encode to [String], not [Encodable], so even ints are wrapped in strings
    
    /// Stores which parameters have to be ecoded in hexadecimal
    fileprivate let hexEncodingIndices: [Int]?
    
    /// Counts the index of the parameters encoded
    fileprivate var index: Int = 0
    public init(_ value: Encodable) {
        
        if let value = value as? JSONRPCHexCodable {
            hexEncodingIndices = value.hexEncodedOrder().0
        } else {
            hexEncodingIndices = nil
        }
    }
}

extension JSONRPCArrayEncoder {
    

    /**
    
     */
    public static func encode<P: Encodable>(_ value: P) throws -> [String] {
        let encoder = JSONRPCArrayEncoder(value)
        try value.encode(to: encoder)
        return encoder.array
    }
}

extension JSONRPCArrayEncoder {
    
    public func encode<P: Encodable>(_ encodable: P) throws {
        let item: String
        if let indices = hexEncodingIndices, indices.contains(index) {
            
            // Encode in hexadecimal
            switch encodable {
            case is Int:
                item = "0x" + String(encodable as! Int, radix: 16)
            case is Int8:
                item = "0x" + String(encodable as! Int8, radix: 16)
            case is Int16:
                item = "0x" + String(encodable as! Int16, radix: 16)
            case is Int32:
                item = "0x" + String(encodable as! Int32, radix: 16)
            case is Int64:
                item = "0x" + String(encodable as! Int64, radix: 16)
            case is UInt:
                item = "0x" + String(encodable as! UInt, radix: 16)
            case is UInt8:
                item = "0x" + String(encodable as! UInt8, radix: 16)
            case is UInt16:
                item = "0x" + String(encodable as! Int16, radix: 16)
            case is Int32:
                item = "0x" + String(encodable as! Int32, radix: 16)
            case is Int64:
                item = "0x" + String(encodable as! Int64, radix: 16)
            case is Data.Type:
                item = "0x" + (encodable as! Data).hexDescription
            case is String.Type:
                if let data = (encodable as! String).data(using: .utf8) {
                    item = data.hexDescription
                } else {
                    throw JSONRPCError.typeNotSupported
                }
            default:
                throw JSONRPCError.typeNotSupported
            }
        } else if let encodable = encodable as? String {
            item = encodable
        } else {
            item = "\(encodable)"
        }
        array.append(item)
        
        index = index + 1
    }
}

extension JSONRPCArrayEncoder: Encoder {
    public var codingPath: [CodingKey] {
        return []
    }
    
    public var userInfo: [CodingUserInfoKey : Any] {
        return [:]
    }
    
    public func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        return KeyedEncodingContainer(KeyedContainer<Key>(encoder: self))
    }
    
    public func unkeyedContainer() -> UnkeyedEncodingContainer {
        return UnkeyedContainer(encoder: self)
    }
    
    public func singleValueContainer() -> SingleValueEncodingContainer {
        return UnkeyedContainer(encoder: self)
    }
    
    private struct KeyedContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
        var encoder: JSONRPCArrayEncoder
        
        var codingPath: [CodingKey] { return [] }
        
        func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
            try encoder.encode(value)
        }
        
        func encodeNil(forKey key: Key) throws {}
        
        func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
            return encoder.container(keyedBy: keyType)
        }
        
        func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
            return encoder.unkeyedContainer()
        }
        
        func superEncoder() -> Encoder {
            return encoder
        }
        
        func superEncoder(forKey key: Key) -> Encoder {
            return encoder
        }
    }
    
    private struct UnkeyedContainer: UnkeyedEncodingContainer, SingleValueEncodingContainer {
        var encoder: JSONRPCArrayEncoder
        
        var codingPath: [CodingKey] { return [] }
        
        var count: Int { return 0 }
        
        func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
            return encoder.container(keyedBy: keyType)
        }
        
        func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
            return self
        }
        
        func superEncoder() -> Encoder {
            return encoder
        }
        
        func encodeNil() throws {}
        
        func encode<T>(_ value: T) throws where T : Encodable {
            try encoder.encode(value)
        }
    }
}