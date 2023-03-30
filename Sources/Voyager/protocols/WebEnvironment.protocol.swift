//
//  WebEnvironment.protocol.swift
//  DiffableSample
//
//  Created by Taras Spasibov on 22.03.2023.
//

import Foundation

public protocol WebEnvironmentProtocol {
  var host: String { get }
  var apiVersion: String { get }
}
