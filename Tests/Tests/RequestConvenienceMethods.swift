//
//  ConvenienceMethods.swift
//  Tests
//
//  Created by Ronald "Danger" Mannak on 4/6/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//

import XCTest
import JSONRPCCodable

func assertRoundtrip<T: JSONRPCRequestCodable>(_ original: T) throws {
    // Encode
    let request = try encode(original)
    let data: JSONRPCRequest<T> = try decode(request)
    let decoded: T = try extract(data)
    XCTAssert(original == decoded)
}

func encode<T: JSONRPCRequestCodable>(_ original: T) throws -> Data {
//    let request = JSONRPCRequest<T>(params: original)
    return try JSONRPCRequestEncoder.encode(original)
}

func decode<T: JSONRPCRequestCodable>(_ data: Data) throws -> JSONRPCRequest<T> {
    let decoder = JSONDecoder()
    return try decoder.decode(JSONRPCRequest<T>.self, from: data)
}

func extract<T: JSONRPCRequestCodable>(_ request: JSONRPCRequest<T>) throws -> T {
    guard let params = request.params else {
        throw UTError.emptyParams
    }
    return params
}

func extractDictionary(_ data: Data) throws -> [String: Any] {
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
        throw UTError.notAValidDictionary
    }
    return dictionary
}

func param<A>(dict: [String: Any], index: Int) throws -> A {
    guard let params = dict["params"] as? [Any] else {
        throw UTError.emptyParams
    }
    guard params.count > index else {
        throw UTError.indexOutOfRange
    }
    guard let value = params[index] as? A else {
        throw UTError.unexpectedType
    }
    return value
}

func params<T: JSONRPCRequestCodable>(codable: T) throws -> [Any] {
    let data = try encode(codable)
    let dict = try extractDictionary(data)
    guard let params = dict["params"] as? [Any] else {
        throw UTError.emptyParams
    }
    return params
}

enum UTError: Error {
    case emptyParams
    case emptyResult
    case notAValidDictionary
    case paramNotFound
    case indexOutOfRange
    case unexpectedType
}
