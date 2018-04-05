//
//  String.swift
//  JSONRPCCodable
//
//  Created by Ronald "Danger" Mannak on 4/2/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//
// https://stackoverflow.com/questions/27189338/swift-native-functions-to-have-numbers-as-hex-strings

import Foundation

extension String {
    
    public var isHex: Bool {
        let string = drop0xPrefix()
        guard string.count % 2 == 0 else { return false }
        guard string.isEmpty == false else { return false }
        
        let chars = CharacterSet(charactersIn: "0123456789ABCDEF").inverted
        return string.uppercased().rangeOfCharacter(from: chars) == nil        
    }
    
    /// Returns true if self has 0x prefix
    public var has0xPrefix: Bool { return hasPrefix("0x") }
    
    /// Removes 0x from self if present
    public func drop0xPrefix() -> String { return has0xPrefix ? String(dropFirst(2)) : self }

//    public func hexToNumeric<T: BinaryInteger>(type: T) -> T? { return T(drop0xPrefix(), radix: 16) }
    
    public var hexToInt:    Int? { return Int(drop0xPrefix(), radix: 16) }
    public var hexToInt8:   Int8? { return Int8(drop0xPrefix(), radix: 16) }
    public var hexToInt16:  Int16? { return Int16(drop0xPrefix(), radix: 16) }
    public var hexToInt32:  Int32? { return Int32(drop0xPrefix(), radix: 16) }
    public var hexToInt64:  Int64? { return Int64(drop0xPrefix(), radix: 16) }
    public var hexToUInt:   UInt? { return UInt(drop0xPrefix(), radix: 16) }
    public var hexToUInt8:  UInt8? { return UInt8(drop0xPrefix(), radix: 16) }
    public var hexToUInt16: UInt16? { return UInt16(drop0xPrefix(), radix: 16) }
    public var hexToUInt32: UInt32? { return UInt32(drop0xPrefix(), radix: 16) }
    public var hexToUInt64: UInt64? { return UInt64(drop0xPrefix(), radix: 16) }
    public var hexToData:   Data? {
        var hex = self.drop0xPrefix()
        var data = Data()
        while(hex.count > 0) {
            let subIndex = hex.index(hex.startIndex, offsetBy: 2)
            let c = String(hex[..<subIndex])
            hex = String(hex[subIndex...])
            var ch: UInt32 = 0
            Scanner(string: c).scanHexInt32(&ch)
            var char = UInt8(ch)
            data.append(&char, count: 1)
        }
        return data
    }
}
