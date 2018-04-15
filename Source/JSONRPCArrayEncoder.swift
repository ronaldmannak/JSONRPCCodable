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
    
    public func encode<P: FixedWidthInteger>(_ encodable: P) throws {
        if let indices = hexEncodingIndices, indices.contains(index) {
            append(encodable.hexValue)
        } else {
            append("\(encodable)")
        }
    }
    
    public func encode<P: Encodable>(_ encodable: P) throws {
//        print("e: \(encodable.self), indices: \(String(describing: hexEncodingIndices))")
        
        if let indices = hexEncodingIndices, indices.contains(index) {
            // This paramater needs to be hex encoded
            switch encodable {
                // Can we do something like... ?
//            case let i = encodable as? FixedWidthInteger:
//                appendHexString(encodable)
            case is Int:
                appendHexString(encodable as! Int)
            case is Int8:
                appendHexString(encodable as! Int8)
            case is Int16:
                appendHexString(encodable as! Int16)
            case is Int32:
                appendHexString(encodable as! Int32)
            case is Int64:
                appendHexString(encodable as! Int64)
            case is UInt:
                appendHexString(encodable as! UInt)
            case is UInt8:
                appendHexString(encodable as! UInt8)
            case is UInt16:
                appendHexString(encodable as! UInt16)
            case is UInt32:
                appendHexString(encodable as! UInt32)
            case is UInt64:
                appendHexString(encodable as! UInt64)
            case is Data:
                append((encodable as! Data).hexDescription)
            case is String:
                guard let data = (encodable as! String).data(using: .utf8) else {
                    throw JSONRPCError.typeNotSupported
                }
                append(data.hexDescription)                    
            case is Codable:
                try encodable.encode(to: self)
            default:
                throw JSONRPCError.typeNotSupported
            }
        } else if let encodable = encodable as? String {
            // Add String (no Hex conversion)
            append(encodable)
        } else {
            append("\(encodable)")
        }
    }
    
    public func append(_ item: String) {
        array.append(item)
        index = index + 1
    }
    
    public func appendHexString<P: FixedWidthInteger>(_ item: P) {
        append(item.hexValue)
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
