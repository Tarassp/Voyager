//
//  Networker.swift
//  DiffableSample
//
//  Created by Taras Spasibov on 22.03.2023.
//

import Foundation
import os

public protocol Networking {
  func perform(_ request: Request, token: String?) async throws -> Data
  func perform(url: String) async throws -> Data
}

public struct Networker: Networking {
  
  private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "")
  
  private let urlSession: URLSession
  private let webEnvironment: WebEnvironmentProtocol
  private let useLogger: Bool
  
  public init(urlSession: URLSession = .shared, webEnvironment: WebEnvironmentProtocol, useLogger: Bool = true) {
    self.urlSession = urlSession
    self.webEnvironment = webEnvironment
    self.useLogger = useLogger
  }
  
  
  public func perform(_ request: Request, token: String?) async throws -> Data {
    let request = try request.createRequest(token: token, webEnvironment: webEnvironment)
    if useLogger {
      NetworkLogger.printRequest(request)
    }
    let (data, response) = try await urlSession.data(for: request)
    if useLogger {
      NetworkLogger.printResponse(request, response, data)
    }
    return try checkResponse(response, data: data)
  }
  
  public func perform(url: String) async throws -> Data {
    guard let url = URL(string: url) else { throw NetworkError.invalidURL }
    let (data, response) = try await urlSession.data(from: url)
    return try checkResponse(response, data: data)
  }
  
  private func checkResponse(_ response: URLResponse, data: Data) throws -> Data {
    guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.notHTTPURLResponse }
    switch httpResponse.statusCode {
    case (200..<300): return data
    case 401: throw NetworkError.unauthorized
    default: throw NetworkError.serverError(statusCode: httpResponse.statusCode, data: data)
    }
  }
}
