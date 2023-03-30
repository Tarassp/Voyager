//
//  Request.protocol.swift
//  DiffableSample
//
//  Created by Taras Spasibov on 22.03.2023.
//

import Foundation

public protocol Request {
  var path: String { get }
  var httpMethod: HttpMethod { get }
  var allHTTPHeaderFields: [String: String]? { get }
  var queryItems: [URLQueryItem]? { get }
  var body: [String: Any]? { get }
  var addAuthorizationToken: Bool { get }
  var scheme: String { get }
}

public extension Request {
  var queryItems: [URLQueryItem]? { nil }
  var allHTTPHeaderFields: [String: String]? { nil }
  var body: [String: Any]? { nil }
  var addAuthorizationToken: Bool { true }
  var scheme: String { "https" }
}

public extension Request {
  func createRequest(token: String?, webEnvironment: WebEnvironmentProtocol) throws -> URLRequest {
    var urlComponents = URLComponents()
    urlComponents.scheme = scheme
    urlComponents.host = webEnvironment.host
    urlComponents.path = webEnvironment.apiVersion + path
    urlComponents.queryItems = queryItems
    
    guard let url = urlComponents.url else { throw NetworkError.invalidURL }
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = httpMethod.rawValue
    urlRequest.allHTTPHeaderFields = allHTTPHeaderFields
    
    if addAuthorizationToken {
      if token == nil {
        throw NetworkError.tokenIsAbsent
      }
      urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
    }
    
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    if let body = body, !body.isEmpty {
      urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
    }
    
    return urlRequest
  }
}
