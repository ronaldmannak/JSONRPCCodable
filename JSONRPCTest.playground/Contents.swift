//: Playground - noun: a place where people can play

import UIKit

/*:
 ### RPC Test

 Goal: Create an easy to use JSONRPC framework, while keeping it possible to encode and decode the same data in JSON API.
 
 JSONRPC specs: (http://www.jsonrpc.org/specification)
 
 ##Possible Solutions for encoding problems:
 
 - in Ethereum, params can in requests are embedded in an array ```[Codable?]```, but that doesn't seem to be a RPC standard. Add an option in RPCEncoder to auto generate an array
 - in Ethereum, empty params are still passed as an empty array (```params: []```), in the RPC specs, it's valid to don't have a params. Add an option in RPCEncoder to add empty array or remove the params key if no params are passed
 - Some Ints and Strings need to be converted into hex, but not all. Expand Encoder protocol, or create new RPCEncoder protocol and add ```var hexCodingPath: [CodingKey?] { get }```
 - Where to add hex translation? Encoder?
 - byParameter is a standard JSON dictionary, but byPosition is not. Order must be maintained, but how do we define order? Introspection? or ```var position: [CodingKey?] { get}```
 - Do we need to create a custom byPositionContainer? or can we fit everything in KeyedContainer, UnkeyedContainer, and SingleValueContainer.
 
 OR
 
 - manually add it to func ```encode(to encoder: RPCEncoder) throws```
 - Where to wrap the data in an RPC structure?
 - can we do something with subclassing, encoder and decoder can use "super"
 
 ##Possible Solutions for decoding problems:
 
 - Most results are single "unkeyed" values in results key.
 - How to tell when a value needs to be converted from hex to Int or String? Int can be done automatically, but string can't. Sometimes you want to keep the hex code (e.g. address), but sometimes the hex contains info (which ones? ExtraData key in eth_getBlockByHash and eth_getFilterChanges. Unkeyed: db_getHex). Can we add an option in RPCDecoder?

 Check
 https://stackoverflow.com/questions/44549310/how-to-decode-a-nested-json-struct-with-swift-decodable-protocol https://medium.com/swiftly-swift/swift-4-decodable-beyond-the-basics-990cc48b7375
 https://stablekernel.com/understanding-extending-swift-4-codable/
 https://github.com/gwynne/XMLRPCSerialization XMLRPC
 
 
 * RPC Request objects:
 Request objects are similarly confusing. The method name is stored in "method". Parameters are either passed by-position or by-name. By-position MUST be an array, by-name must be a dictionary. A simple method is:
 
```{"jsonrpc":"2.0","method":"eth_getTransactionCount","params":["0x407d73d8a49eeb85d32cf465507dd71d507100c1","latest"],"id":1}```
 
 A more complex one, with dictionary as params looks like this. Note that the dictionary is wrapped inside an array:
 
 ```{"jsonrpc":"2.0","method":"eth_sendTransaction","params":[{"from":"0xb60e8dd61c5d32be8058bb8eb970870f07233155","to":"0xd46e8dd67c5d32be8058bb8eb970870f07244567","gas":"0x76c0","gasPrice":"0x9184e72a000","value":"0x9184e72a","data":"0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675"}],"id":1}```
 
 The id is a counter or random number, used by the client to distinguish requests. The server will always respond with a response object with the same id as the request.

 * RPC Response objects:
 RPC wraps its data in the "result" value, and the value could be any valid JSON type: string, int, float, an array of valid JSON types or a dictionary of valid JSON types. The challenge is that often only the value is stored in result, without a key. Although the RPC specs don't specify it for response types, Ethereum/web3 basically makes use of by-name or by-position. For example, Ethereum's result for version number in JSONRPC is:

 ```{"jsonrpc":"2.0","id":67,"result":"Geth/v1.7.2-stable-1db4ecdc/darwin-amd64/go1.9.1"}```
 
 while the JSON API version would be:
 
 ```{"version":"Geth/v1.7.2-stable-1db4ecdc/darwin-amd64/go1.9.1", id:67}```
 
 * RPC Error Response objects:
 Similar to regular response objects, but with an error key and error dictionary as value:

 ```{"jsonrpc":"2.0","id":67,"error":{"code":-32601,"message":"The method web3_clientVersion2 does not exist/is not available"}}```

 ## Encoding for Ethereum
 When encoding QUANTITIES (integers, numbers): encode as hex, prefix with "0x", the most compact representation (slight exception: zero should be represented as "0x0"). Examples:
 
 - 0x41 (65 in decimal)
 - 0x400 (1024 in decimal)
 - WRONG: 0x (should always have at least one digit - zero is "0x0")
 - WRONG: 0x0400 (no leading zeroes allowed)
 -  WRONG: ff (must be prefixed 0x)
 
 When encoding UNFORMATTED DATA (byte arrays, account addresses, hashes, bytecode arrays): encode as hex, prefix with "0x", two hex digits per byte. Examples:
 
 - 0x41 (size 1, "A")
 - 0x004200 (size 3, "\0B\0")
 - 0x (size 0, "")
 - WRONG: 0xf0f0f (must be even number of digits)
 - WRONG: 004200 (must be prefixed 0x)
 

 
 Test 1: Can we create a JSONRPCEncoder and JSONRPCDecoder that works with Codable?
 (https://github.com/apple/swift/blob/master/stdlib/public/SDK/Foundation/JSONEncoder.swift)
 
 How JSONEcoder works:
 
 ```open class JSONEncoder is the public facing class.```
 
 JSONEncoder does not conform Encoder.
 
 ```open func encode creates a _JSONEncoder with options of JSONEncoder```
 
 ```fileprivate class _JSONEconder: Encoder hides the
 
    fileprivate struct _JSONEncodingStorage
 
 (stack)
 
 ```fileprivate struct _JSONKeyedEncodingContainer<K : CodingKey> : KeyedEncodingContainerProtocol```
 */

extension Int {
    var hexValue: String {
        return ""
    }
}

extension String {
    var hexValue: String {
        return ""
    }
}


public typealias RPCCodable = RPCDecodable & RPCEncodable

public protocol RPCDecodable: Decodable {
    init(from decoder: RPCDecoder) throws
}

public protocol RPCEncodable: Encodable {
    func encode(to encoder: RPCEncoder) throws
}

public protocol HexCodingKey: CodingKey {
    
}

//// OR
//extension CodingKey {
//    public var hexValue: String? { get }
//}

// OR

public protocol RPCEncoder: Encoder {
    var codingPath: [CodingKey?] { get }
    var userInfo: [CodingUserInfoKey : Any] { get }
    
    func container<Key>(keyedBy type: Key.Type)
        -> KeyedEncodingContainer<Key> where Key : CodingKey
    func unkeyedContainer() -> UnkeyedEncodingContainer // if order is guaranteed
    func singleValueContainer() -> SingleValueEncodingContainer
}

public protocol PRCDecoder: Decoder {
    /// The path of coding keys taken to get to this point in decoding.
    //public var codingPath: [CodingKey] { get }
    var hexCodingPath: [CodingKey] { get }
    
    /// Any contextual information set by the user for decoding.
    //public var userInfo: [CodingUserInfoKey : Any] { get }
    
    var codingPath: [CodingKey?] { get }
    var userInfo: [CodingUserInfoKey : Any] { get }
    
    func container<Key>(keyedBy type: Key.Type) throws
        -> KeyedDecodingContainer<Key> where Key : CodingKey
    func unkeyedContainer() throws -> UnkeyedDecodingContainer
    func singleValueContainer() throws -> SingleValueDecodingContainer
}

/*
 can we create a
 HexCodingKey
/// A type that can be used as a key for encoding and decoding.
public protocol CodingKey {
    
    /// The string to use in a named collection (e.g. a string-keyed dictionary).
    public var stringValue: String { get }
    
    /// Creates a new instance from the given string.
    ///
    /// If the string passed as `stringValue` does not correspond to any instance of this type, the result is `nil`.
    ///
    /// - parameter stringValue: The string value of the desired key.
    public init?(stringValue: String)
    
    /// The value to use in an integer-indexed collection (e.g. an int-keyed dictionary).
    public var intValue: Int? { get }
    
    /// Creates a new instance from the specified integer.
    ///
    /// If the value passed as `intValue` does not correspond to any instance of this type, the result is `nil`.
    ///
    /// - parameter intValue: The integer value of the desired key.
    public init?(intValue: Int)
}

*/

enum RPCStructure { case byName, byPosition }

protocol RPCRequest: Codable {
    static var rpcMethod: String { get }
    static var rpcParams: Codable { get }
    static var paramsStructure: RPCStructure { get }
    //static var responseType<T: Codable>: T.Type { get } // Can we add the expected response type here?
}

/* Default values */
extension RPCRequest {
    static var rpcParams: Codable { return [] }
    static var paramsStructure: RPCStructure { return .byName }
    //static var responseType: Codable { return String.self }
}

/*
 Clientversion
 Request: {"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":67}
 Response: {"jsonrpc":"2.0","id":67,"result":"Geth/v1.7.2-stable-1db4ecdc/darwin-amd64/go1.9.1"}
 */
typealias Clientversion = String

struct ClientversionRequest: RPCRequest {
    static let rpcMethod = "web3_clientVersion"
}

// To encode an RPC request
let rpcRequest = ClientversionRequest()
let rpcEncoder = JSONRPCEncoder()
let rpcData = try! rpcEncoder.encode(rpcRequest)
let rpcString = String(data: rpcData, encoding: .utf8)!
print(rpcString) // "{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":67}"

// To decode an RPC response
let rpcResponse = "{\"jsonrpc\":\"2.0\",\"id\":67,\"result\":\"Geth/v1.7.2-stable-1db4ecdc/darwin-amd64/go1.9.1\"}".data(using: .utf8)!
let rpcDecoder = JSONRPCDecoder()
let rpcVersion = try! rpcDecoder.decode(Clientversion.self, from: rpcResponse)
print (rpcVersion) // "Geth/v1.7.2-stable-1db4ecdc/darwin-amd64/go1.9.1\"

// Encoding to JSON should still be possible
let jsonRequest = ClientversionRequest()
let encoder = JSONEncoder()
let jsonData = try! encoder.encode(jsonRequest)
let jsonString = String(data: jsonData, encoding: .utf8)!
print(jsonString) // "{"method":"web3_clientVersion","id":67}"

// Decoding to JSON should still be possible
let jsonResponse = "{\"id\":67,\"clientVersion\":\"Geth/v1.7.2-stable-1db4ecdc/darwin-amd64/go1.9.1\"}".data(using: .utf8)!
let jsonDecoder = JSONDecoder()
let jsonVersion = try! jsonDecoder.decode(Clientversion.self, from: jsonResponse)
print (jsonVersion) // "Geth/v1.7.2-stable-1db4ecdc/darwin-amd64/go1.9.1\"

// TODO: Make sure position of params is correct in byPosition, e.g.:
// '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":83}'




/*
open class JSONRPCEncoder: JSONEncoder {
    open override func encode<T : Encodable>(_ value: T) throws -> Data {
        let encoder = _JSONRPCEncoder(options: self.options)
        return Data()
    }
}

open class JSONRPCDecoder: JSONDecoder {
    
}

fileprivate class _JSONRPCEncoder: Encoder {
    public var codingPath: [CodingKey] = []
    
    public var userInfo: [CodingUserInfoKey : Any]
    
    public func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        <#code#>
    }
    
    public func unkeyedContainer() -> UnkeyedEncodingContainer {
        <#code#>
    }
    
    public func singleValueContainer() -> SingleValueEncodingContainer {
        <#code#>
    }
    
    
}

fileprivate class _JSONRPCDecoder: Decoder {
    public var codingPath: [CodingKey]
    
    public var userInfo: [CodingUserInfoKey : Any]
    
    public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        <#code#>
    }
    
    public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        <#code#>
    }
    
    public func singleValueContainer() throws -> SingleValueDecodingContainer {
        <#code#>
    }
    
    
}
*/
