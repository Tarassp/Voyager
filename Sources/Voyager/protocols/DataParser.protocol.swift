//
//  DataParser.protocol.swift
//  DiffableSample
//
//  Created by Taras Spasibov on 23.03.2023.
//

import Foundation

public protocol DataParserProtocol {
  func parse<D: Decodable>(_ data: Data) throws -> D
}
