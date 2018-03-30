//
//  JSONRPCRequestEncoder.swift
//  Example
//
//  Created by Ronald "Danger" Mannak on 2/27/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//

import Foundation

/**
 Convenience JSONRPC Encoder
 */
public final class JSONRPCRequestEncoder {
    public static func encode<P: JSONRPCCodable>(_ value: P) throws -> Data {
        let encoder = JSONRPCRequestEncoder()
        return try encoder.encode(value)
    }
}

public extension JSONRPCRequestEncoder {
    
    /**
     
     */
    public func encode<P: JSONRPCCodable>(_ encodable: P) throws -> Data {
        
        // Wrap in JSONRPCRequest
        let request = JSONRPCRequest<P>(params: encodable)
        return try JSONEncoder().encode(request)
    }
}
