//
//  JSONRPCRequestDecoder.swift
//  Example
//
//  Created by Ronald "Danger" Mannak on 2/27/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//

import Foundation

/**
 Convenience JSONRPC Decoder
 */
public final class JSONRPCRequestDecoder {
    
    public func decode<T>(_ type: T.Type, from: Data) throws -> JSONRPCRequest<T> where T: JSONRPCCodable {
        let decoder = JSONDecoder()
        return try decoder.decode(JSONRPCRequest<T>.self, from: from)
    }
}
