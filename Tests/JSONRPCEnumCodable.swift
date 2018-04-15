//
//  JSONRPCEnumCodable.swift
//  JSONRPCCodable
//
//  Created by Ronald "Danger" Mannak on 4/13/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//

import Foundation

public protocol JSONRPCEnumCodable: Equatable {
    func encodeEnum(to encoder: JSONRPCArrayEncoder) throws
    init(from decoder: JSONRPCArrayDecoder) throws
}
