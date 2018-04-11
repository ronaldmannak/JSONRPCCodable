//
//  Tests.swift
//  Tests
//
//  Created by Ronald "Danger" Mannak on 2/28/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//

import XCTest
import JSONRPCCodable

class RequestCodableTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEmptyParamsByPosition() {
        struct Ethversion: JSONRPCCodable {
            static func method() -> String { return "eth_version" }
        }

        do {
            let ethVersion = Ethversion()
            try assertRoundtrip(ethVersion)
        } catch {
            XCTFail("Unexpected Error: \(error)")
        }
    }
    
    func testEmptyParamsByName() {
        struct Ethversion: JSONRPCCodable {
            static func method() -> String { return "eth_version" }
            static func paramEncoding() -> JSONRPCParamStructure { return .byName }
        }

        do {
            let ethVersion = Ethversion()
            try assertRoundtrip(ethVersion)
        } catch {
            XCTFail("Unexpected Error: \(error)")
        }
    }

    func testParameterByName() {
        struct ParamByName: JSONRPCCodable {
            let param1: String
            let param2: Int

            static func method() -> String { return "ParamByName" }
            static func paramEncoding() -> JSONRPCParamStructure { return .byName }
            static func wrapParamsInArray() -> Bool { return true }
        }
        do {
            let p = ParamByName(param1: "FirstParameter", param2: 31)
            try assertRoundtrip(p)
        } catch {
            XCTFail("Unexpected Error: \(error)")
        }
    }
    
    func testParameterByPosition() {
        struct ParamByName: JSONRPCCodable {
            let param1: String
            let param2: Int64

            static func method() -> String { return "ParamByName" }
            static func paramEncoding() -> JSONRPCParamStructure { return .byPosition }
        }
        do {
            let p = ParamByName(param1: "FirstParameter", param2: 31)
            try assertRoundtrip(p)
        } catch {
            XCTFail("Unexpected Error: \(error)")
        }
    }
    
    func testDecode() {
        struct ParamByName: JSONRPCCodable {
            let param1: String
            let param2: Int
            
            static func method() -> String { return "ParamByName" }
            static func paramEncoding() -> JSONRPCParamStructure { return .byName }
        }
        do {
            let p = ParamByName(param1: "FirstParameter", param2: 31)
            let jsonData = "{\"jsonrpc\":\"2.0\",\"method\":\"ParamByName\",\"id\":1,\"params\":[{\"param2\":31,\"param1\":\"FirstParameter\"}]}".data(using: .utf8)!

            guard let jsonStruct = try JSONDecoder().decode(JSONRPCRequest<ParamByName>.self, from: jsonData).params else {
                XCTFail("params is nil")
                return
            }
            XCTAssertEqual(p, jsonStruct)
        } catch {
            XCTFail("Unexpected Error: \(error)")
        }
    }
    
}




