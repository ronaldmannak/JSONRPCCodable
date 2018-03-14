//: Playground - noun: a place where people can play

import Foundation

/*
 TODO:
 - Add sequential numbers
 -
 - Make Decodable
 */

public enum JSONRPCParamStructure { case byName, byPosition }

protocol JSONRPCDecodable: Decodable {
    // TODO
}

protocol JSONRPCEncodable: Encodable {
    func method() -> String
    func paramEncoding() -> JSONRPCParamStructure
    func id() -> Int64
    //    func empty/skip params param if empty
//    func shouldWrapParamsInArray -> Bool
}

// Default implementation for JSONRPCEncodable
extension JSONRPCEncodable {
    func id() -> Int64 {
        // TODO: add threadsafe function to generate sequential numbers.
        // OR should we create the id when encoding? We probably want to do that at the latest possible moment
        return 1
    }
    
    func paramEncoding() -> JSONRPCParamStructure {
        return .byPosition
    }
}

typealias JSONRPCCodable = JSONRPCDecodable & JSONRPCEncodable

struct JSONRPCRequest<P: JSONRPCCodable>: Codable {
    let jsonrpc: String = "2.0"
    let method: String
    let params: P?
    let id: Int64
    
    enum CodingKeys : String, CodingKey {
        case jsonrpc, method, params, id
    }
    
    // Custom encoding of request
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(jsonrpc, forKey: .jsonrpc)
        try container.encode(method, forKey: .method)
        if let params = params {
            // Add a check if params is empty. If no params, the params key should either absent or just be an empty array, depending on JSONRPCEncodable's func showParamsKeyIfNoParamsArePresent() -> Bool (or something shorter)
            // How do we check if params is empty? It's not that we can count the keys, can we?
            
            switch params.paramEncoding() {
            case .byName:
                print("By name")
                // TODO: For now, we encode the dictionary in an array, as Ethereum expects. In the future, adding a func shouldWrapParamsInArray() -> Bool to JSONRPCEncodable might make sense
                var container = container.nestedUnkeyedContainer(forKey: .params)
                try container.encode(params)
            case .byPosition:
                print("By position")
                // Encode data into an array
                let array = try ArrayEncoder.encode(params)
                try container.encode(array, forKey: .params)
            }
        }
        try container.encode(id, forKey: .id)
    }
}

// Custom encoder for JSONRPC
// We really don't need this anymore, since we encode the requests with a standard encoder, but let's keep it for now for convenience

class JSONRPCEncoder {
    static func encode<P: JSONRPCCodable>(_ value: P) throws -> String {
        let encoder = JSONRPCEncoder()
        return try encoder.encode(value)
    }
}

extension JSONRPCEncoder {
    func encode<P: JSONRPCCodable>(_ encodable: P) throws -> String {
        let request = JSONRPCRequest<P>(method: encodable.method(), params: encodable, id: encodable.id())
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(request)
        return String(data: data, encoding: .utf8)!
    }
}

// Custom array encoder
public class ArrayEncoder {
    var array = [String]()
}

extension ArrayEncoder {
    /**
     Current limitation: encode can only encode to [String], not [Encodable], so even ints are wrapped in strings
     */
    static func encode<P: Encodable>(_ value: P) throws -> [String] {
        let encoder = ArrayEncoder()
        try value.encode(to: encoder)
        return encoder.array
    }
}

extension ArrayEncoder {
    
    func encode<P: Encodable>(_ encodable: P) throws {
        array.append("\(encodable)")
    }
}

extension ArrayEncoder: Encoder {
    public var codingPath: [CodingKey] {
        return []
    }
    
    public var userInfo: [CodingUserInfoKey : Any] {
        return [:]
    }
    
    public func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        return KeyedEncodingContainer(KeyedContainer<Key>(encoder: self))
    }
    
    public func unkeyedContainer() -> UnkeyedEncodingContainer {
        return UnkeyedContainer(encoder: self)
    }
    
    public func singleValueContainer() -> SingleValueEncodingContainer {
        return UnkeyedContainer(encoder: self)
    }
    
    private struct KeyedContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
        var encoder: ArrayEncoder
        
        var codingPath: [CodingKey] { return [] }
        
        func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
            try encoder.encode(value)
        }
        
        func encodeNil(forKey key: Key) throws {}
        
        func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
            return encoder.container(keyedBy: keyType)
        }
        
        func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
            return encoder.unkeyedContainer()
        }
        
        func superEncoder() -> Encoder {
            return encoder
        }
        
        func superEncoder(forKey key: Key) -> Encoder {
            return encoder
        }
    }
    
    private struct UnkeyedContainer: UnkeyedEncodingContainer, SingleValueEncodingContainer {
        var encoder: ArrayEncoder
        
        var codingPath: [CodingKey] { return [] }
        
        var count: Int { return 0 }
        
        func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
            return encoder.container(keyedBy: keyType)
        }
        
        func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
            return self
        }
        
        func superEncoder() -> Encoder {
            return encoder
        }
        
        func encodeNil() throws {}
        
        func encode<T>(_ value: T) throws where T : Encodable {
            try encoder.encode(value)
        }
    }
}





// Tests

struct Ethversion: JSONRPCCodable {
    func method() -> String {
        return "eth_version"
    }
}

struct EthBlockInfo: JSONRPCCodable {
    let address: String // TODO: hex convertible
    let block: String
    let counter: Int
    
    func method() -> String {
        return "eth_blockInfo" // just a made up method
    }
}

struct RandomEthMethod: JSONRPCCodable {
    let from: String
    let to: String
    
    func method() -> String {
        return "eth_randomMethod"
    }
    
    func paramEncoding() -> JSONRPCParamStructure {
        return .byName
    }
}

do {
    let ethVersion = Ethversion()
    let result1 = try JSONRPCEncoder.encode(ethVersion)
    print(result1)
    
    let ethBlockInfo = EthBlockInfo(address: "0x12345", block: "latest", counter: 42)
    let result2 = try JSONRPCEncoder().encode(ethBlockInfo)
    print(result2)
    
    let random = RandomEthMethod(from: "0x1234", to: "0x3456")
    let result3 = try JSONRPCEncoder().encode(random)
    print(result3)
    
} catch {
    print("error: \(error)")
}
