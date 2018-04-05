//
//  TypeTests.swift
//  Tests
//
//  Created by Ronald "Danger" Mannak on 4/4/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//

import XCTest
import JSONRPCCodable

class TypeTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIsHexString() {
        let s1 = "0x01FF0154" // Valid hex
        XCTAssert(s1.isHex == true)
        
        let s2 = "0x12XHJ2" // Invalid hex characters
        XCTAssert(s2.isHex == false)
        
        let s3 = "0x12AE453" // Invalid: odd number of characters
        XCTAssert(s3.isHex == false)
    }
}
