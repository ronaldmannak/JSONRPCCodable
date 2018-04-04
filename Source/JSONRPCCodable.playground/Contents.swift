//: Playground - noun: a place where people can play

import Cocoa

public protocol HexEncodable {
    static var hexKeys: [String] { get }
    func hexEncodedOrder() -> ([Int], [String])
    func shouldHexEncode(index: Int) -> Bool
    func shouldHexEncode(label: String) -> Bool
}

public extension HexEncodable {
    static var hexKeys: [String] { return [] }
    
    func hexEncodedOrder() -> ([Int], [String]) {
        let mirror = Mirror(reflecting: self)
        var i = 0
        var indices = [Int]()
        var labels = [String]()
        for child in mirror.children {
            if let label = child.label, type(of: self).hexKeys.contains(label) == true {
//                print("Index \(i) should be hex codable: \(label)")
                indices.append(i)
                labels.append(label)
            }
            i = i + 1
        }
        return (indices, labels)
    }
    
    func shouldHexEncode(index: Int) -> Bool {
        let order = hexEncodedOrder().0
        return order.contains(index)
    }
    
    func shouldHexEncode(label: String) -> Bool {
        let labels = hexEncodedOrder().1
        return labels.contains(label)
    }
}

struct TestStruct: HexEncodable {
    let param1: String
    let param2: Int
    let param3: String
    
    static let hexKeys = ["param1", "param3"]
    enum HexKeys: String {
        case param1, param2
    }
}

let test1 = TestStruct(param1: "Hello", param2: 42, param3: "World")
print(test1.hexEncodedOrder())

assert(test1.shouldHexEncode(index: 0) == true)
assert(test1.shouldHexEncode(index: 1) == false)
assert(test1.shouldHexEncode(index: 2) == true)
assert(test1.shouldHexEncode(label: "param1") == true)
assert(test1.shouldHexEncode(label: "param2") == false)
assert(test1.shouldHexEncode(label: "param3") == true)


