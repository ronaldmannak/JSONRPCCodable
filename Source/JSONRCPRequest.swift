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
public struct JSONRPCRequest<P: JSONRPCCodable>: Codable {
    let jsonrpc: String
    var id: Int64
    let params: P?
    
    enum CodingKeys : String, CodingKey {
        case jsonrpc, method, params, id
    }
    
    /**
     Custom encoding of request
     */
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(jsonrpc, forKey: .jsonrpc)
        try container.encode(P.method(), forKey: .method)
        if let params = params {
            // Add a check if params is empty. If no params, the params key should either absent or just be an empty array, depending on JSONRPCEncodable's func showParamsKeyIfNoParamsArePresent() -> Bool (or something shorter)
            // How do we check if params is empty? It's not that we can count the keys, can we?
            
            switch P.paramEncoding() {
            case .byName:
                if P.wrapParamsInArray() == true {
                    try container.encode([params], forKey: .params)
                    // TODO: This creates [{}] as params
                    // We want: params:[] or no params at all
                    // Encode nil? or Custom Encoder like ArrayEncoder that returns nil?
                } else {
                    // Encode P as dictionary not wrapped in an array
                    try container.encode(params, forKey: .params)
                }
            case .byPosition:
                print("By position")
                // Encode data into an array
                let array = try ArrayEncoder.encode(params)
                try container.encode(array, forKey: .params)
            }
        }
        try container.encode(id, forKey: .id)
    }
    
    /**
     */
    public init(params: P, id: Int64? = nil, jsonrpc: String = rpcVersion) {
        self.jsonrpc = jsonrpc
        self.params = params
        self.id = id ?? 1 // TODO: Create threadsafe sequential numbers.
    }
    
    /**
     
     Note that init from decoder expects a JSONRPCRequest struct
     */
    public init(from decoder: Decoder) throws {        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int64.self, forKey: .id)
        let jsonrpc = try container.decode(String.self, forKey: .jsonrpc)
        let params: P
        switch P.paramEncoding() {
        case .byName:
            if P.wrapParamsInArray() == true {
                guard let paramElement = try Array<P>(from: decoder).first else {
                    throw Error.noParametersFound
                }
                params = paramElement
            } else {
                fatalError() // Not implemented yet
            }
        case .byPosition:
            fatalError()
//            Use ArrayDecoder
        }
        
        self.init(params: params, id: id, jsonrpc: jsonrpc)
    }
    
    enum Error: Swift.Error {
        case noParametersFound
    }
}
