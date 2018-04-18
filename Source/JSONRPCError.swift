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
    
    case typeNotConformingToJSONRPCResponseCodable(Encodable.Type)
    
    // Enum
    case unknownType(Any)
    
    /// Encapsulation of JSON RPC response error sent from a JSON RPC server
    case responseError(code: Int, message: String, data: Data?)
}

public extension JSONRPCError {
    
    /**
     */
    init(error: Data) throws {
        struct JSONRPCResponseError: Decodable {
            let code: Int
            let message: String
            let data: Data?
        }
        let error = try JSONDecoder().decode(JSONRPCResponseError.self, from: error)
        self = .responseError(code: error.code, message: error.message, data: error.data)
    }
}

extension JSONRPCError: Equatable {
    public static func == (lhs: JSONRPCError, rhs: JSONRPCError) -> Bool {
        switch (lhs, rhs) {
        case (.responseError(let lhsError), .responseError(let rhsError)):
            return lhsError.code == rhsError.code && lhsError.message == rhsError.message
        default:
            // Not implemented
            fatalError()
        }
    }
}
