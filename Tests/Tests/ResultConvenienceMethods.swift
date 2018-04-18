//
//  ResultConvenienceMethods.swift
//  Tests
//
//  Created by Ronald "Danger" Mannak on 4/16/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//

import XCTest
import JSONRPCCodable

func assertRoundtrip<T: JSONRPCResponseCodable>(_ original: T) throws {
    // Encode
    let request = try encode(original)
    let data: JSONRPCResponse<T> = try decode(request)
    let decoded: T = try extract(data)
    XCTAssert(original == decoded)
}

func encode<T: JSONRPCResponseCodable>(_ original: T) throws -> Data {
    return try JSONRPCResponseEncoder.encode(original)
}

func decode<T: JSONRPCResponseCodable>(_ data: Data) throws -> JSONRPCResponse<T> {
    let decoder = JSONDecoder()
    return try decoder.decode(JSONRPCResponse<T>.self, from: data)
}

func extract<T: JSONRPCResponseCodable>(_ response: JSONRPCResponse<T>) throws -> T {
    guard let result = response.result else {
        throw UTError.emptyResult
    }
    return result
}

//func param<A>(dict: [String: Any], index: Int) throws -> A {
//    guard let params = dict["params"] as? [Any] else {
//        throw UTError.emptyParams
//    }
//    guard params.count > index else {
//        throw UTError.indexOutOfRange
//    }
//    guard let value = params[index] as? A else {
//        throw UTError.unexpectedType
//    }
//    return value
//}
//
//func params<T: JSONRPCResultCodable>(codable: T) throws -> [Any] {
//    let data = try encode(codable)
//    let dict = try extractDictionary(data)
//    guard let params = dict["params"] as? [Any] else {
//        throw UTError.emptyParams
//    }
//    return params
//}
