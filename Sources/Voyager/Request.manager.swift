//
//  Request.manager.swift
//  DiffableSample
//
//  Created by Taras Spasibov on 17.03.2023.
//

import Foundation


public protocol RequestManagerProtocol {
  func fetch<D: Decodable>(_ request: Request) async throws -> D
  func fetch(from url: String) async throws -> Data
}

public struct RequestManager: RequestManagerProtocol {
  
  private let networker: Networking
  private let dataParser: DataParserProtocol
  private let accessTokenManager: AccessTokenManagerProtocol
  private let resignInManager: ResignInManagerProtocol?
  
  public init(networker: Networking,
       accessTokenManager: AccessTokenManagerProtocol,
       resignInManager: ResignInManagerProtocol?,
       dataParser: DataParserProtocol) {
    self.networker = networker
    self.dataParser = dataParser
    self.accessTokenManager = accessTokenManager
    self.resignInManager = resignInManager
  }
  
  
  public func fetch<D: Decodable>(_ request: Request) async throws -> D {
    let token = request.addAuthorizationToken ? try await requestAccessToken() : nil
    do {
      let data = try await networker.perform(request, token: token)
      return try dataParser.parse(data)
    } catch NetworkError.unauthorized {
      resignInManager?.makeResignIn()
      throw NetworkError.unauthorized
    }
  }
  
  public func fetch(from url: String) async throws -> Data {
    try await networker.perform(url: url)
  }
  
  private func requestAccessToken() async throws -> String? {
    if accessTokenManager.hasToken == false {
      return try await signIn()
    } else if accessTokenManager.isExpared() {
      return try await refreshAccessToken()
    }
    return try await accessTokenManager.getToken()
  }
  
  private func refreshAccessToken() async throws -> String? {
    let data = try await networker.perform(accessTokenManager.refreshTokenRequest, token: nil)
    return accessTokenManager.setToken(data)
  }
  
  private func signIn() async throws -> String? {
    let data = try await networker.perform(accessTokenManager.signInRequest, token: nil)
    return accessTokenManager.setToken(data)
  }
}
