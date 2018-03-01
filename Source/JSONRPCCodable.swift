//
//  JSONRPCCodable.swift
//  Example
//
//  Created by Ronald "Danger" Mannak on 2/27/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//

/// Convenience shortcut to conform to JSONRPCEncodable and JSONRPCDecodable
public typealias JSONRPCCodable = JSONRPCEncodable & JSONRPCDecodable

/// Supported RPC version, currently 2.0
public let rpcVersion = "2.0"
