//
//  JSONRPCCodableExtension.swift
//  Example
//
//  Created by Ronald "Danger" Mannak on 2/27/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//

import Foundation

import Foundation

extension Array: JSONRPCCodable {
    public func binaryEncode(to encoder: JSONRPCEncoder) throws {
        guard Element.self is Encodable.Type else {
            throw JSONRPCEncoder.Error.typeNotConformingToEncodable(Element.self)
        }
        
        try encoder.encode(self.count)
        for element in self {
            try (element as! Encodable).encode(to: encoder)
        }
    }
    
    public init(fromBinary decoder: JSONRPCDecoder) throws {
        guard let binaryElement = Element.self as? Decodable.Type else {
            throw JSONRPCDecoder.Error.typeNotConformingToDecodable(Element.self)
        }
        
        let count = try decoder.decode(Int.self)
        self.init()
        self.reserveCapacity(count)
        for _ in 0 ..< count {
            let decoded = try binaryElement.init(from: decoder)
            self.append(decoded as! Element)
        }
    }
}

extension String: JSONRPCCodable {
    public func binaryEncode(to encoder: JSONRPCEncoder) throws {
        try Array(self.utf8).binaryEncode(to: encoder)
    }
    
    public init(fromBinary decoder: JSONRPCDecoder) throws {
        let utf8: [UInt8] = try Array(fromBinary: decoder)
        if let str = String(bytes: utf8, encoding: .utf8) {
            self = str
        } else {
            throw JSONRPCDecoder.Error.invalidUTF8(utf8)
        }
    }
}
