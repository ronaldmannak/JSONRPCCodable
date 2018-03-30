//
//  ArrayDecoder.swift
//  JSONRPCCodable
//
//  Created by Ronald "Danger" Mannak on 3/23/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//

import Foundation

public class ArrayDecoder {
    fileprivate var data: Data
    public var decodeHexStrings: Bool = true

    public init(data: Data) {
        self.data = data
    }
}

public extension ArrayDecoder {

    public static func decode<T: Decodable>(_ type: T.Type, from: Data) throws -> T {
        return try ArrayDecoder(data: from).decode(T.self)
    }
}

public extension ArrayDecoder {
    
//    func decode(_ type: String.Type) throws -> String {
//        if decodeHexStrings == true &&
//    }
//
//    func decode(_ type: Int.Type) throws -> Int {
//
//    }
}

extension ArrayDecoder: Decoder {
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
    
    
}
