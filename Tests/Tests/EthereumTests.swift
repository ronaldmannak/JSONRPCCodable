//
//  EthereumTests.swift
//  Tests
//
//  Created by Ronald "Danger" Mannak on 4/4/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//

import XCTest
import JSONRPCCodable

class EthereumTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testGetTransactionByBlock() {
//
//        struct TransactionByBlock: JSONRPCCodable, JSONRPCHexCodable {
//            enum DefaultBlock: JSONRPCHexCodable {
//
//                case blockNumber(Int)
//                case earliest, latest, pending
//
//                static var hexKeys: [String] { return ["blockNumber"] }
//            }
//            let blockNumber: Int
//
//
//            let quantity: Int
//
//            static func method() -> String {
//                return "eth_getTransactionByBlockNumberAndIndex"
//            }
//        }
//
//        // {"jsonrpc":"2.0","method":"eth_getTransactionByBlockNumberAndIndex","params":["0x29c", "0x0"],"id":1}
//
////        let
//    }

    // Expected request:
    // {"jsonrpc":"2.0","method":"eth_getUncleByBlockHashAndIndex","params":["0xc6ef2fc5426d6ad6fd9e2a26abeab0aa2411b7ab17f30a99d3cb96aed1d1055b", "0x0"],"id":1}
    func testGetUncleByBlockHash() {
        
        
        struct UncleByBlockHash: JSONRPCCodable, JSONRPCHexCodable {            
            let blockHash: String
            let unclePosition: Int
            
            static func method() -> String { return "eth_getUncleByBlockHashAndIndex" }
            static var hexKeys: [String] { return ["unclePosition"] }
        }
        
        let uncle = UncleByBlockHash(blockHash: "0xc6ef2fc5426d6ad6fd9e2a26abeab0aa2411b7ab17f30a99d3cb96aed1d1055b", unclePosition: 0)
        
        do {
            try assertRoundtrip(uncle)
            
            let encodedParams = try params(codable: uncle)
            XCTAssertEqual(encodedParams as! [String], ["0xc6ef2fc5426d6ad6fd9e2a26abeab0aa2411b7ab17f30a99d3cb96aed1d1055b", "0x0"])
        } catch {
            XCTFail("Unexpected Error: \(error)")
        }
    }
    
    // eth_uninstallFilter

}
