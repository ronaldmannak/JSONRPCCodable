//
//  JSONRPCResponse.swift
//  JSONRPCCodable
//
//  Created by Ronald "Danger" Mannak on 4/15/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//

import Foundation

/**
 
 Note: If we could make P conform Encodable and Equatable instead of JSONRPCResponseCodable, we could simplify decoding by simply returning a String, Int or Bool
 */
public struct JSONRPCResponse<P: JSONRPCResponseCodable>: Equatable {
    
    public enum Result: Equatable {
        case result(P)
        case error(JSONRPCError)
    }

    public let jsonrpc: String
    public var id: Int
    public let result: Result
    
    enum CodingKeys : String, CodingKey {
        case id, jsonrpc, result
    }
    
    public init(id: Int, jsonrpc: String = rpcVersion, result: P) {
        self.id = id
        self.jsonrpc = jsonrpc
        self.result = .result(result)
    }
    
    public init(id: Int, jsonrpc: String = rpcVersion, error: JSONRPCError) {
        self.id = id
        self.jsonrpc = jsonrpc
        self.result = .error(error)
    }
    
}

extension JSONRPCResponse: Codable {
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(jsonrpc, forKey: .jsonrpc)
        
        switch P.structure() {
        case .byName:
            try container.encode(result, forKey: .result)
        case .byPosition:
            // Encode data into an array
            let array = try JSONRPCArrayEncoder.encode(result)
            try container.encode(array, forKey: .result)
        }
    }
    
    public init(from decoder: Decoder) throws {
        fatalError()
    }
}
