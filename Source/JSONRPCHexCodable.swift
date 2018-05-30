//
//  JSONRPCHexCodable.swift
//  JSONRPCCodable
//
//  Created by Ronald "Danger" Mannak on 4/4/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//

import Foundation

/**
 For data types that have properties that need to be hex encoded. 
 */
public protocol JSONRPCHexCodable {
    static var hexKeys: [String] { get }
    func hexEncodedOrder() -> ([Int], [String])
    func shouldHexEncode(index: Int) -> Bool
    func shouldHexEncode(label: String) -> Bool
}

public extension JSONRPCHexCodable {
 
    // TODO: Clean up this code
    // We also might want to throw if hexKeys contains a key that is not in children
    func hexEncodedOrder() -> ([Int], [String]) {
        let mirror = Mirror(reflecting: self)
        var hexIndices = [Int]()
        var hexLabels = [String]()
        for (i, child) in mirror.children.enumerated() {
            if let label = child.label, type(of: self).hexKeys.contains(label) == true {
                hexIndices.append(i)
                hexLabels.append(label)
            }
        }
        return (hexIndices, hexLabels)
    }
    
    func shouldHexEncode(index: Int) -> Bool {
        let order = hexEncodedOrder().0
        return order.contains(index)
    }
    
    func shouldHexEncode(label: String) -> Bool {
        let labels = hexEncodedOrder().1
        return labels.contains(label)
    }
}


