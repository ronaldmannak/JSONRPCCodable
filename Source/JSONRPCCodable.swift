//
//  JSONRPCCodable.swift
//  Example
//
//  Created by Ronald "Danger" Mannak on 2/27/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//

/// Convenience shortcuts
public typealias JSONRPCRequestCodable = JSONRPCRequestEncodable & JSONRPCRequestDecodable
public typealias JSONRPCResultCodable = JSONRPCResultEncodable & JSONRPCResultDecodable

/// Supported RPC version, currently 2.0
public let rpcVersion = "2.0"

public struct JSONRPCRequest: Codable {
    let jsonrpc: String
    let method: String
//    let params: [Codable]
    // Issue: Params could be either an array of Codables, or an dictionary of [String: Codable]. 
    // https://stackoverflow.com/questions/44441223/encode-decode-array-of-types-conforming-to-protocol-with-jsonencoder
    // https://github.com/realm/realm-cocoa/issues/5437
    // http://lebedev.cc/swifts-decodable-gotchas/
    // https://forums.developer.apple.com/thread/80288
    let id: Int
}

