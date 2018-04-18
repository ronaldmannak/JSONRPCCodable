//
//  JSONRPCID.swift
//  JSONRPCCodable
//
//  Created by Ronald "Danger" Mannak on 4/15/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//

import Foundation

/**
 Auto-incrementing id for RPC Id variable
 
 Source: https://stackoverflow.com/questions/30851339/how-do-i-atomically-increment-a-variable-in-swift
 */
public struct JSONRPCID {
    private static let lock = DispatchSemaphore(value: 1)
    private static var id = 1
    
    // You need to lock on the value when reading it too since
    // there are no volatile variables in Swift as of today.
    public static func get() -> Int {
        lock.wait()
        defer { lock.signal() }
        return JSONRPCID.id
    }
    
    public static func set(_ newValue: Int) {
        lock.wait()
        defer { lock.signal() }
        JSONRPCID.id = newValue
    }
    
    public static func incrementAndGet() -> Int {
        lock.wait()
        defer { lock.signal() }
        JSONRPCID.id = JSONRPCID.id + 1
        return JSONRPCID.id
    }
}
