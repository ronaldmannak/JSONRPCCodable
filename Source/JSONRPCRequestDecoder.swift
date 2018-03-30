//
//  JSONRPCRequestDecoder.swift
//  Example
//
//  Created by Ronald "Danger" Mannak on 2/27/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//


// Can we use AddtionalInfoKeys to fetch the params?
// https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types

import Foundation

public final class JSONRPCRequestDecoder {
    
    var decodeHexData: Bool = true
    
    
//    func decode<T: JSONRPCCodable>(_ type: T.type, from: Data) throws -> T {
//
//
//        JSONRPCRequest<T>
//
//    }
    
//    func decode<T: JSONRPCCodable>(_ type: T.Type, from: Data) throws -> T {
//
//        // Create
//
//        let request = JSONRPCRequest<T>
//
//        return try JSONRPCRequestDecoder(data: data).decode(T.self)
//    }
}

public extension JSONRPCRequestDecoder {
    
    func decode<T: JSONRPCCodable>(_ type: T.Type, from: Data) throws -> T {
        //
    }
    
    func decode<T: Decodable>(_ type: T.Type, from: Data) -> T {
        
    }
    
    func decode(_ type: Bool.Type) throws -> Bool {
        
    }
    
}

public extension JSONRPCRequestDecoder {
    enum Error: Swift.Error {
        
        /**
         Attempted to decode a type which is not a JSONRPCRequest
         */
        case typeNotJSONRPCRequest
        
        /// Attempted to decode a type which is not `Decodable`.
        case typeNotConformingToDecodable(Any.Type)
    }
}

extension JSONRPCRequestDecoder: Decoder {
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
        var decoder: JSONRPCRequestDecoder
        
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
        
        var count: Int? { return nil }
        
        var currentIndex: Int { return 0 }
        
        var isAtEnd: Bool { return false }
        
        var decoder: JSONRPCRequestDecoder
        
        var codingPath: [CodingKey] { return [] }
        
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

