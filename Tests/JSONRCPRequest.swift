//
//  JSONRCPRequest.swift
//  JSONRPCCodable
//
//  Created by Ronald "Danger" Mannak on 3/13/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//

import Foundation

public struct JSONRPCRequest<P: JSONRPCCodable>: Codable {
    let jsonrpc: String = rpcVersion
    let method: String
    let params: P?
    let id: Int64
    
    enum CodingKeys : String, CodingKey {
        case jsonrpc, method, params, id
    }
    
    // Custom encoding of request
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(jsonrpc, forKey: .jsonrpc)
        try container.encode(method, forKey: .method)
        if let params = params {
            // Add a check if params is empty. If no params, the params key should either absent or just be an empty array, depending on JSONRPCEncodable's func showParamsKeyIfNoParamsArePresent() -> Bool (or something shorter)
            // How do we check if params is empty? It's not that we can count the keys, can we?
            
            switch params.paramEncoding() {
            case .byName:
                print("By name")
                // TODO: For now, we encode the dictionary in an array, as Ethereum expects. In the future, adding a func shouldWrapParamsInArray() -> Bool to JSONRPCEncodable might make sense
                var container = container.nestedUnkeyedContainer(forKey: .params)
                try container.encode(params)
            case .byPosition:
                print("By position")
                // Encode data into an array
                let array = try ArrayEncoder.encode(params)
                try container.encode(array, forKey: .params)
            }
        }
        try container.encode(id, forKey: .id)
    }
}
