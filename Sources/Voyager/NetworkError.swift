//
//  NetworkError.swift
//  DiffableSample
//
//  Created by Taras Spasibov on 17.03.2023.
//

import Foundation

public enum NetworkError: LocalizedError {
  case invalidServerResponse
  case invalidURL
  case notHTTPURLResponse
  case notConnectedToInternet
  case dataNotAllowed
  case networkConnectionLost
  case tokenIsAbsent
  case tokenIsExpaired
  case unauthorized
  case parseError(String)
  case serverError(statusCode: Int, data: Data)
  
  public var errorDescription: String? {
    switch self {
    case .invalidServerResponse:
      return "The server returned an invalid response."
    case .invalidURL:
      return "URL string is bad."
    case .notConnectedToInternet:
      return "No Internet Connection"
    case .dataNotAllowed:
      return "The cellular network disallowed a connection."
    case .networkConnectionLost:
      return "Network Connection Lost"
    case .tokenIsAbsent:
      return "Token is nil"
    case .tokenIsExpaired:
      return "Token is expired!"
    case .unauthorized:
        return "Unauthorized. Please re-Sign In"
    case .notHTTPURLResponse:
      return "Can't make downcast from URLResponse to HTTPURLResponse"
    case .parseError(let error):
      return "PARSE ERROR: \(error)"
    case .serverError(let statusCode, let data):
      return "Status code: \(statusCode)\n\(String(data: data, encoding: .utf8) ?? "")"
    }
  }
}
