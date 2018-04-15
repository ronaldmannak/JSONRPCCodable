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
    
    
    // Expected:
    // {"jsonrpc":"2.0","method":"eth_getTransactionByBlockNumberAndIndex","params":["0x29c", "0x0"],"id":1}
    func testGetTransactionByBlock() {

        struct TransactionByBlock: JSONRPCCodable, JSONRPCHexCodable {
            
            enum DefaultBlock: Codable, Equatable {
                
                case blockNumber(Int)
                case earliest, latest, pending
                
                init(from decoder: Decoder) throws {
                    
                    if let decoder = decoder as? JSONRPCArrayDecoder {
                        guard let value = decoder.readCurrent() as? String else {
                            throw JSONRPCError.typeNotSupported
                        }
                        if let blockNumber = value.hexToInt {
                            self = .blockNumber(blockNumber)
                        } else if value == "earliest" {
                            self = .earliest
                        } else if value == "latest" {
                            self = .latest
                        } else if value == "pending" {
                            self = .pending
                        } else {
                            throw JSONRPCError.typeNotSupported
                        }
                    } else {
                        throw JSONRPCError.typeNotSupported
                    }
                }
                
                func encode(to encoder: Encoder) throws {
                    if let encoder = encoder as? JSONRPCArrayEncoder {
                        switch self {
                        case .earliest:
                            encoder.append("earliest")
                        case .latest:
                            encoder.append("latest")
                        case .pending:
                            encoder.append("pending")
                        case .blockNumber(let number):
                            encoder.append(number.hexValue)
                        }
                    } else {
                        throw JSONRPCError.typeNotSupported
                    }
                }
            }
            
            let blockNumber: DefaultBlock
            let indexPosition: Int

            static func method() -> String {
                return "eth_getTransactionByBlockNumberAndIndex"
            }
            
            static var hexKeys: [String] { return ["blockNumber", "indexPosition"] } //<- this doesn't work in JSONRPCArrayEncoder:57 since DefaultBlock isn't a known type
        }

        let transaction = TransactionByBlock(blockNumber: .blockNumber(668), indexPosition: 0)
        do {
            try assertRoundtrip(transaction)
            let encodedParams = try params(codable: transaction)
            XCTAssertEqual(encodedParams as! [String], ["0x029c", "0x00"])
        } catch {
            XCTFail("Unexpected Error: \(error)")
        }
    }
    
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
            XCTAssertEqual(encodedParams as! [String], ["0xc6ef2fc5426d6ad6fd9e2a26abeab0aa2411b7ab17f30a99d3cb96aed1d1055b", "0x00"])
        } catch {
            XCTFail("Unexpected Error: \(error)")
        }
    }
    
    // eth_uninstallFilter
    // Expected result: {"jsonrpc":"2.0","method":"eth_uninstallFilter","params":["0xb"],"id":73}
    
    func testEthUninstallFilter() {
        struct UninstallFilter: JSONRPCCodable, JSONRPCHexCodable, Equatable {
            let filterId: Int
            static func method() -> String { return "eth_uninstallFilter" }
            static var hexKeys: [String] { return ["filterId"] }
        }
        let filter = UninstallFilter(filterId: 11)
        do {
            try assertRoundtrip(filter)
            let encodedParams = try params(codable: filter)
            XCTAssertEqual(encodedParams as! [String], ["0x0b"])
        } catch {
            XCTFail("Unexpected Error: \(error)")
        }
    }

}
