//
//  AccessTokenManager.protocol.swift
//  DiffableSample
//
//  Created by Taras Spasibov on 23.03.2023.
//

import Foundation

public protocol AccessTokenManagerProtocol {
  var hasToken: Bool { get }
  func isExpared() -> Bool
  func getToken() async throws -> String?
  func setToken(_ data: Data) -> String?
  var signInRequest: Request { get }
  var refreshTokenRequest: Request { get }
}
