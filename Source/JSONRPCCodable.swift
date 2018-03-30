//
//  JSONRPCCodable.swift
//  Example
//
//  Created by Ronald "Danger" Mannak on 2/27/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//

import Foundation

/**
 */
public protocol JSONRPCCodable: Codable { //JSONRPCEncodable: Encodable {
    static func method() -> String
    static func paramEncoding() -> JSONRPCParamStructure
    //    func empty/skip params param if empty
    //    func shouldWrapParamsInArray -> Bool
}

// Default implementation for JSONRPCCodable
public extension JSONRPCCodable {
    
    /**
     Default parameter encoding is .byPosition
     */
    static func paramEncoding() -> JSONRPCParamStructure {
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
