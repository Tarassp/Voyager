//
//  NetworkLogger.swift
//  DiffableSample
//
//  Created by Taras Spasibov on 30.03.2023.
//

import Foundation

struct NetworkLogger {
  static func printRequest(_ urlRequest: URLRequest) {
#if DEBUG
    var request = "\n====REQUEST=================================\n"
    
    if let method = urlRequest.httpMethod {
      request += "\(method)"
      
      if let url = urlRequest.url {
        request += " \(url.absoluteString) \n"
      } else {
        request += "\n"
      }
    }
    
    if let headers = urlRequest.allHTTPHeaderFields {
      for (header, value) in headers {
        request += "-H \"\(header): \(value)\" \\\n"
      }
    }
    
    if let body = urlRequest.httpBody, !body.isEmpty, let string = String(data: body, encoding: .utf8), !string.isEmpty {
      request += "-d '\(string)' \\\n"
    }
    
    request += "============================================"
    print(request)
#endif
  }
  
  static func printResponse(_ urlRequest: URLRequest, _ response: URLResponse, _ data: Data) {
#if DEBUG
    let httpUrlResponse = response as? HTTPURLResponse
    let statusCode = httpUrlResponse?.statusCode ?? 0
    var responseString = "\n====RESPONSE================================\n"
    if let method = urlRequest.httpMethod {
      
      responseString += "\(statusCode) \(method)"
      
      if let url = urlRequest.url {
        responseString += " \(url.absoluteString) \n"
      } else {
        responseString += "\n"
      }
    }
    if let headers = httpUrlResponse?.allHeaderFields {
      for (header, value) in headers {
        responseString += "-H \"\(header): \(value)\" \\\n"
      }
    }
    
    if  !data.isEmpty, let string = String(data: data, encoding: .utf8), !string.isEmpty {
      responseString += "-d '\(string)' \\\n"
    }
    
    responseString += "============================================"
    
    print(responseString)
#endif
  }
}
