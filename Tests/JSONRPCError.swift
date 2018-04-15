//
//  JSONRPCError.swift
//  JSONRPCCodable
//
//  Created by Ronald "Danger" Mannak on 4/4/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//

import Foundation

public enum JSONRPCError: Error {
    
    
    
    // JSONRPCCodable Errors
    case noParametersFound
    case typeNotSupported
    
    // JSONRPCHexCodable Errors
    
    // JSONRPCArrayEncoder
    
    /// JSONRPCArrayEncoder decoder hit the end of the data while the values it was decoding expected more.
    case prematureEndOfData
    
    /// Attempted to decode a type which is `Decodable`, but not `BinaryDecodable`. (We
    /// require `BinaryDecodable` because `BinaryDecoder` doesn't support full keyed
    /// coding functionality.)
    case typeNotConformingToJSONRPCCodable(Decodable.Type)
    
    // Enum
    case unknownType(Any)
    
}
