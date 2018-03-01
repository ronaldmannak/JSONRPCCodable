//
//  Tests.swift
//  Tests
//
//  Created by Ronald "Danger" Mannak on 2/28/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//

import XCTest
import JSONRPCCodable

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        XCTFail()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

// Requests
struct ClientVesionRequest: JSONRPCCodable {
    let method = "web3_clientVersion"
    //{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":67}
}

struct Sha3: JSONRPCCodable {
    //{"jsonrpc":"2.0","method":"web3_sha3","params":["0x68656c6c6f20776f726c64"],"id":64}
}

struct BlockTransactionCount {
    // Make sure string isn't converted to hex
    // {"jsonrpc":"2.0","method":"eth_getBlockTransactionCountByNumber","params":["earliest"],"id":1}
}

struct Code {
    // {"jsonrpc":"2.0","method":"eth_getCode","params":["0xa94f5374fce5edbc8e2a8697c15331677e6ebf0b", "genesis"],"id":1}
}

struct SendTransaction {
    /*
     Make sure it gets encoded as a dictionary / byName
    {"jsonrpc":"2.0","method":"eth_sendTransaction","params":[{"from":"0xb60e8dd61c5d32be8058bb8eb970870f07233155","to":"0xd46e8dd67c5d32be8058bb8eb970870f07244567","gas":"0x76c0","gasPrice":"0x9184e72a000","value":"0x9184e72a","data":"0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675"}],"id":1}
 */
}
