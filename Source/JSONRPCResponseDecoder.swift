//
//  JSONRPCResponseDecoder.swift
//  Example
//
//  Created by Ronald "Danger" Mannak on 2/27/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//

import Foundation

/// JSONRPC Response decoder class.
public class JSONRPCResponseDecoder {
    
    public func decode<T>(_ type: T.Type, from: Data) throws -> JSONRPCResponse<T> where T: JSONRPCResponseCodable {
        let decoder = JSONDecoder()
        return try decoder.decode(JSONRPCResponse<T>.self, from: from)
    }
}

