//
//  JSONRPCCodable.swift
//  Example
//
//  Created by Ronald "Danger" Mannak on 2/27/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//

import Foundation

/**
 Protocol used for JSON
 */
public protocol JSONRPCRequestCodable: JSONRPCResultCodable {
    static func method() -> String
}

public protocol JSONRPCResultCodable: Codable, Equatable {
    static func paramEncoding() -> JSONRPCParamStructure
    
    /// If true, the dictionary of the by name parameters will be wrapped in an array when encoded in a .byName dictionary
    static func wrapParamsInArray() -> Bool
}

// Default implementations for JSONRPCResultCodable
public extension JSONRPCResultCodable {
    /**
     Default parameter encoding is .byPosition
     */
    static func paramEncoding() -> JSONRPCParamStructure {
        return .byPosition
    }
    
    static func wrapParamsInArray() -> Bool {
        return true
    }
}

/// Supported RPC version, currently 2.0
public let rpcVersion = "2.0"

/**
 Defines whether parameters needs ot be encoded by name or position.
 E.g. eth_getCode's params need to be encoded by position: ["0xa94f5374fce5edbc8e2a8697c15331677e6ebf0b", "genesis"]
 eth_sendTransaction's params need to be encoded byName: [{"from":"0xb60e8dd61c5d32be8058bb8eb970870f07233155","to":"0xd46e8dd67c5d32be8058bb8eb970870f07244567",...}]
 */
public enum JSONRPCParamStructure { case byName, byPosition }
