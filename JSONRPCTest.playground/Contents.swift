//: Playground - noun: a place where people can play

import UIKit

/*:
 ### RPC Test

 Goal: Create an easy to use JSONRPC framework, while keeping it possible to encode and decode the same data in JSON API.
 
 JSONRPC specs: (http://www.jsonrpc.org/specification)
 
 * RPC Request objects:
 Request objects are similarly confusing. The method name is stored in "method". Parameters are either passed by-position or by-name. By-position MUST be an array, by-name must be a dictionary. A simple method is:
 
```{"jsonrpc":"2.0","method":"eth_getTransactionCount","params":["0x407d73d8a49eeb85d32cf465507dd71d507100c1","latest"],"id":1}```
 
 A more complex one, with dictionary as params looks like this:
 
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

// To encode a request
let request = Clientversion()
let rpcEncoder = JSONRPCEncoder()
let rpcData = try! rpcEncoder.encode(request)
let rpcString = String(data: jsonData, encoding: .utf8)
print(rpcString) // Should be {"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":67}

// To decode a response
let rpcResponse = "{\"jsonrpc\":\"2.0\",\"id\":67,\"result\":\"Geth/v1.7.2-stable-1db4ecdc/darwin-amd64/go1.9.1\"}".utf8
let rpcDecoder = JSONRPCDecoder()
let version = rpcEncoder.decode(Clientversion.self, from: rpcResponse)
print (version)

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
