//
//  Int.swift
//  Tests
//
//  Created by Ronald "Danger" Mannak on 4/5/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//

import Foundation

extension FixedWidthInteger {
    
    /**
     
     Note: Ethereum sometimes uses single digit hex numbers for numbers smaller than 16. For simplicity, we're always returning an even number of digits, even for numbers smaller than 16.
     */
    public var hexValue: String {
        let hex = String(self, radix: 16, uppercase: false)
        return hex.count % 2 == 0 ? "0x" + hex : "0x0" + hex
    }
}
