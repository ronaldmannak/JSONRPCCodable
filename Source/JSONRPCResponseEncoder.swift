//
//  JSONRPCResponseEncoder.swift
//  Example
//
//  Created by Ronald "Danger" Mannak on 2/27/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//

import Foundation

/**
 Convenience JSONRPC Response Encoder
 */
public final class JSONRPCResponseEncoder {
    public static func encode<P: JSONRPCResponseCodable>(_ value: P) throws -> Data {
        let encoder = JSONRPCResponseEncoder()
        return try encoder.encode(value)
    }
}

public extension JSONRPCResponseEncoder {
    
    /**
     
     */
    public func encode<P: JSONRPCResponseCodable>(_ encodable: P) throws -> Data {
        return try JSONEncoder().encode(encodable)
    }
}

