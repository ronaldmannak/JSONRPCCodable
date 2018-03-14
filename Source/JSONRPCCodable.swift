//
//  JSONRPCCodable.swift
//  Example
//
//  Created by Ronald "Danger" Mannak on 2/27/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//

import Foundation

/// Convenience shortcut
public typealias JSONRPCCodable = JSONRPCDecodable & JSONRPCEncodable

/**
 */
public protocol JSONRPCDecodable: Decodable {
    // TODO
}

/**
 */
public protocol JSONRPCEncodable: Encodable {
    func method() -> String
    func paramEncoding() -> JSONRPCParamStructure
    func id() -> Int64
    //    func empty/skip params param if empty
    //    func shouldWrapParamsInArray -> Bool
}

// Default implementation for JSONRPCEncodable
public extension JSONRPCEncodable {
    
    /**
     Creates threadsafe sequential numbers.
     */
    func id() -> Int64 {
        // TODO: add threadsafe function to generate sequential numbers.
        // OR should we create the id when encoding? We probably want to do that at the latest possible moment
        return 1
    }
    
    /**
     Default parameter encoding is .byPosition
     */
    func paramEncoding() -> JSONRPCParamStructure {
        return .byPosition
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
