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
public class JSONRPCRequestEncoder {
    public static func encode<P: JSONRPCCodable>(_ value: P) throws -> String {
        let encoder = JSONRPCRequestEncoder()
        return try encoder.encode(value)
    }
}

public extension JSONRPCRequestEncoder {
    
    /**
     Returns string for debugging purposes
     */
    public func encode<P: JSONRPCCodable>(_ encodable: P) throws -> String { // TODO: make encodable return Data
        let request = JSONRPCRequest<P>(method: encodable.method(), params: encodable, id: encodable.id())
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(request)
        return String(data: data, encoding: .utf8)!
    }
}
