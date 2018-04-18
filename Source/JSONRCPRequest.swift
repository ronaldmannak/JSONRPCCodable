//
//  JSONRCPRequest.swift
//  JSONRPCCodable
//
//  Created by Ronald "Danger" Mannak on 3/13/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//

import Foundation

/**

 */
public struct JSONRPCRequest<P: JSONRPCRequestCodable>: Codable, Equatable {
    public let jsonrpc: String
    public let id: Int
    public let params: P?
    
    enum CodingKeys : String, CodingKey {
        case jsonrpc, method, params, id
    }
    
    /**
     Custom encoding of request
     */
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(jsonrpc, forKey: .jsonrpc)
        
        try container.encode(id, forKey: .id)
        if let params = params {
            switch P.paramEncoding() {
            case .byName:
                if P.wrapParamsInArray() == true {
                    try container.encode([params], forKey: .params)
                } else {
                    // Encode P as dictionary not wrapped in an array
                    try container.encode(params, forKey: .params)
                }
            case .byPosition:
                // Encode data into an array
                let array = try JSONRPCArrayEncoder.encode(params)
                try container.encode(array, forKey: .params)
            }
        }
    }
    
    /**
     */
    public init(params: P, id: Int? = nil, jsonrpc: String = rpcVersion) {
        self.jsonrpc = jsonrpc
        self.params = params
        self.id = id ?? JSONRPCID.incrementAndGet()
    }
    
    /**
     
     Note that init from decoder expects a JSONRPCRequest struct
     */
    public init(from decoder: Decoder) throws {        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let jsonrpc = try container.decode(String.self, forKey: .jsonrpc)
        let result: P
        
        switch P.paramEncoding() {
        case .byName:
            result = try container.decode(P.self, forKey: .params)
        case .byPosition:
            let array = try container.decode([String].self, forKey: .params)
            if array.isEmpty {
                result = try P(from: decoder)
            } else {
                let decoder = JSONRPCArrayDecoder(array: array)
                result = try P(from: decoder)
            }
        }
        self.init(params: result, id: id, jsonrpc: jsonrpc)
    }
}

