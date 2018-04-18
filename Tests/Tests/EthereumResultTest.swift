//
//  EthereumResultTest.swift
//  Tests
//
//  Created by Ronald "Danger" Mannak on 4/15/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//

import Foundation

import XCTest
import JSONRPCCodable

class EthereumResultTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    // Simple Result
    // {"id":67, "jsonrpc": "2.0", "result": "3"}
    func testSimpleResult() {
        
        let result = JSONRPCResponse(id: 67, result: 3)
    
        // roundtrip
        // check result == 3
        
    }
    

    // Hex Result
    // {"id":74, "jsonrpc": "2.0", "result": "0x2"}
    func testHexResult() {
        struct Wrapper: Codable, JSONRPCHexCodable {
            let value: Int
            static let hexKeys = ["value"]
        }
    }
    
    
    // eth_syncing result
    // {"id":1, "jsonrpc": "2.0", "result": {
    // startingBlock: '0x384',
    // currentBlock: '0x386',
    // highestBlock: '0x454'}
    // }
    // Or when not syncing
    // {"id":1, "jsonrpc": "2.0", "result": false}
    func testEthSyncing() {
        struct SyncResult: Codable, Equatable {
            let startingBlock: Int
            let currentBlock: Int
            let highestBlock: Int
        }
        enum Syncing: JSONRPCCodable, Codable, Equatable {
            case syncing(SyncResult)
            case notSyncing
            
            init(from decoder: Decoder) throws {
                if let decoder = decoder as? JSONRPCArrayDecoder {
                    if let value = decoder.readCurrent() as? Bool, value == false {
                        self = .notSyncing
                    } else {
                        fatalError()
                    }
                } else {
                    throw JSONRPCError.typeNotSupported
                }
            }
            
            func encode(to encoder: Encoder) throws {
                if let encoder = encoder as? JSONRPCArrayEncoder {
                    switch self {
                    case .notSyncing:
                        encoder.append("false")
                    case .syncing(let result):
//                        var container = encoder.unkeyedContainer()
//                        JSONRPCArrayEncoder ...
                        fatalError()
                    }
                } else {
                    throw JSONRPCError.typeNotSupported
                }
            }
        }
        
        
    }
    
    
    // eth_accounts
    // { "id":1, "jsonrpc": "2.0", "result": ["0x407d73d8a49eeb85d32cf465507dd71d507100c1"] }
    func testEthAccounts() {
        
        let accounts = ["0x407d73d8a49eeb85d32cf465507dd71d507100c1"]
        let response = JSONRPCResponse<[String]>(result: accounts, id: 1)
                
        do {
//            try assertRoundtrip(accounts)
//            
//            let encodedParams = try result(codable: accounts)
//            XCTAssertEqual(encodedParams as! [String], ["0x407d73d8a49eeb85d32cf465507dd71d507100c1"])
        } catch {
            XCTFail("Unexpected Error: \(error)")
        }
    }
    
    // eth_getBlockByHash
    // {"id":1,
    // "jsonrpc":"2.0",
    // "result": {
    // "number": "0x1b4", // 436
    // "hash": "0xe670ec64341771606e55d6b4ca35a1a6b75ee3d5145a99d05921026d1527331",
    // "parentHash": "0x9646252be9520f6e71339a8df9c55e4d7619deeb018d2a3f2d21fc165dde5eb5",
    // "nonce": "0xe04d296d2460cfb8472af2c5fd05b5a214109c25688d3704aed5484f9a7792f2",
    // "sha3Uncles": "0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347",
    // "logsBloom": "0xe670ec64341771606e55d6b4ca35a1a6b75ee3d5145a99d05921026d1527331",
    // "transactionsRoot": "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
    // "stateRoot": "0xd5855eb08b3387c0af375e9cdb6acfc05eb8f519e419b874b6ff2ffda7ed1dff",
    // "miner": "0x4e65fda2159562a496f9f3522f89122a3088497a",
    // "difficulty": "0x027f07", // 163591
    // "totalDifficulty":  "0x027f07", // 163591
    // "extraData": "0x0000000000000000000000000000000000000000000000000000000000000000",
    // "size":  "0x027f07", // 163591
    // "gasLimit": "0x9f759", // 653145
    // "gasUsed": "0x9f759", // 653145
    // "timestamp": "0x54e34e8e" // 1424182926
    // "transactions": [{...},{ ... }]
    // "uncles": ["0x1606e5...", "0xd5145a9..."]}
    // }
    
    // eth_getTransactionByHash
    // {"id":1, "jsonrpc":"2.0", "result": {
    // "hash":"0xc6ef2fc5426d6ad6fd9e2a26abeab0aa2411b7ab17f30a99d3cb96aed1d1055b",
    // "nonce":"0x",
    // "blockHash": "0xbeab0aa2411b7ab17f30a99d3cb9c6ef2fc5426d6ad6fd9e2a26a6aed1d1055b",
    // "blockNumber": "0x15df", // 5599
    // "transactionIndex":  "0x1", // 1
    // "from":"0x407d73d8a49eeb85d32cf465507dd71d507100c1",
    // "to":"0x85h43d8a49eeb85d32cf465507dd71d507100c1",
    // "value":"0x7f110" // 520464
    // "gas": "0x7f110" // 520464
    // "gasPrice":"0x09184e72a000",
    // "input":"0x603880600c6000396000f300603880600c6000396000f3603880600c6000396000f360",}
    // }
    
    // eth_getTransactionReceipt
    // {"id":1, "jsonrpc":"2.0", "result": {
    // transactionHash: '0xb903239f8543d04b5dc1ba6579132b143087c68db1b2168786408fcbce568238',
    // transactionIndex:  '0x1', // 1
    // blockNumber: '0xb', // 11
    // blockHash: '0xc6ef2fc5426d6ad6fd9e2a26abeab0aa2411b7ab17f30a99d3cb96aed1d1055b',
    // cumulativeGasUsed: '0x33bc', // 13244
    // gasUsed: '0x4dc', // 1244
    // contractAddress: '0xb60e8dd61c5d32be8058bb8eb970870f07233155' // or null, if none was created
    // logs: [{
    // logs as returned by getFilterLogs, etc.
    // }, ...],
    // logsBloom: "0x00...0" // 256 byte bloom filter
    // status: '0x1' }
    // }

    // eth_getCompilers
    // {"id":1, "jsonrpc": "2.0", "result": ["solidity", "lll", "serpent"] }

    

    // Test errors
}
