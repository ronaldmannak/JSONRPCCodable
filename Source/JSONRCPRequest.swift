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
public struct JSONRPCRequest<P: JSONRPCCodable>: Codable, Equatable {
    public let jsonrpc: String
    public var id: Int64
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
        try container.encode(P.method(), forKey: .method)
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
                let array = try ArrayEncoder.encode(params)
                try container.encode(array, forKey: .params)
            }
        }
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
                // Parameter dictionary is wrapped in an array
                guard let paramElement = try container.decode([P].self, forKey: .params).first else {
                    throw Error.noParametersFound
                }
                params = paramElement
            } else {
                // Parameters are not wrapped in an array
                params = try container.decode(P.self, forKey: .params)
            }
        case .byPosition:
            print("Start")
            var paramContainer = try container.nestedUnkeyedContainer(forKey: .params) // this container expects Array<P>! Not unnamed properties in an array
            params = try paramContainer.decode(P.self) // decodeIfPresent
            print(params)
            
            // Option: create NoParamsContainer in JSONRPCDecoder and change init to: public init(from decoder: JSONPCDecoder) throws {
            
//            let paramData = try container.decode(String.self, forKey: .params)
//            print(paramData)
//            params = try ArrayDecoder.decode(P.self, from: paramData)
//            params = try container.decode(P.self, forKey: .params)
//            print("End")
//            print (params)
        }
        
        self.init(params: params, id: id, jsonrpc: jsonrpc)
    }
    
    enum Error: Swift.Error {
        case noParametersFound
    }
}

