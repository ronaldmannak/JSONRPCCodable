//: Playground - noun: a place where people can play

import Foundation

public protocol HexEncodable {
    static var hexKeys: [String] { get }
//    func returning the order of params that need to be hex encoded? -> [Int]
    // func returning a Bool if a parameter needs to be hex encoded? -> Bool
    // func returning Bool if a index of parameters needs to be hex encoded -> Bool

    static var hexEncodedOrder: [Int] { get }
}

public extension HexEncodable {
    static var hexKeys: [String] { return [] }

    static var hexEncodedOrder: [Int] {
//        let mirror = Mirror(reflecting: self)
//        for child in mirror.children {
//            print("value: \(child.value)")
//        }
        return []
    }
}

struct TestStruct: HexEncodable {
    let param1: String
    let param2: Int
    let param3: String

    static let hexKeys = ["param1", "param2"]
    enum HexKeys: String {
        case param1, param2
    }
}

let test1 = TestStruct(param1: "Hello", param2: 42, param3: "World")
print("1")
print(TestStruct.hexEncodedOrder)
print("2")

//let structMirror = Mirror(reflecting: test1)
//for child in structMirror.children {
//    print("label: " + child.label!)
//    print("value: \(child.value)")
//}
//let enumMirror = Mirror(reflecting: test1.hexKeys)
//print(enumMirror)
//for child in enumMirror.children {
//    print("value: \(child.value)")
//}
