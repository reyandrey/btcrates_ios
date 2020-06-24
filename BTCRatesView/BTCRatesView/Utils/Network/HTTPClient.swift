//
//  APIClient.swift
//  BTCRatesView
//
//  Created by Andrey on 12.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

protocol APIEndpoint {
  var method: HTTPMethod { get }
  var url: URL { get }
}

extension HTTPClient {
  enum ErrorType: Error {
    case clientError(code: Int, data: Data?)
    case serverError(code: Int)
    case networkError(error: Error)
    case serializationError
    case missingResponse
    case other(message: String)
  }
}

class HTTPClient {
  open var httpHeaders: [String: String] {
    return [String: String]()
  }
  
  private var httpManager: HTTPRequestManager = HTTPRequestManager(defaultHeaders: [String: String]())
  
  func request(to endpoint: APIEndpoint, data: Data? = nil, completionHandler: @escaping (Result<Data?, ErrorType>) -> Void) {
    httpManager.sendRequest(endpoint.method, to: endpoint.url, withPayload: data, headers: httpHeaders) { (data, response, error) in
      
      if let error = error { completionHandler(.failure(.networkError(error: error))); return }
      
      guard let response = response as? HTTPURLResponse else { completionHandler(.failure(.missingResponse)); return }
      
      let code = response.statusCode
      
      switch code {
      case 200..<400: completionHandler(.success(data))
      case 400..<500: completionHandler(.failure(.clientError(code: code, data: data)))
      case 500..<600: completionHandler(.failure(.serverError(code: code)))
      default: completionHandler(.failure(.other(message: "\(response.debugDescription)")))
      }
    }
  }
}
