//
//  HTTPRequestManager.swift
//  Forismatic
//
//  Created by Andrey on 04.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case delete = "DELETE"
  case put = "PUT"
}

public class HTTPRequestManager {
  private let log = Log<HTTPRequestManager>()
  
  public var defaultHeaders: [String: String]
  
  public init(defaultHeaders: [String: String] = [:]) {
    self.defaultHeaders = defaultHeaders
  }
}

//MARK: Public Methods

public extension HTTPRequestManager {
  func sendRequest(_ httpMethod: HTTPMethod = .get, to url: URL, withPayload payload: Data? = nil, headers: [String: String]? = nil,
                   onCompletion completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    
    let sessionConfig = URLSessionConfiguration.default
    sessionConfig.timeoutIntervalForRequest = 10.0
    sessionConfig.timeoutIntervalForResource = 10.0
    let session = URLSession(configuration: sessionConfig)
    
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod.rawValue
    let headers = headers ?? defaultHeaders
    headers.forEach {
      request.setValue($0.value, forHTTPHeaderField: $0.key)
    }
    
    let taskCompletionHandler = { (data: Data?, response: URLResponse?, error: Error?) in
      let stringData = String(data: data ?? Data(), encoding: .utf8) ?? ""
      self.log.debug("did complete request with response \(response.debugDescription) and data: \(stringData)")
      completionHandler(data, response, error)
    }
    
    var task: URLSessionTask
    if let data = payload {
      task = session.uploadTask(with: request, from: data, completionHandler: taskCompletionHandler)
    } else {
      task = session.dataTask(with: request, completionHandler: taskCompletionHandler)
    }
    let stringData = String(data: payload ?? Data(), encoding: .utf8) ?? ""
    log.debug("will perform request to: \(request.debugDescription) and data:\(stringData)")
    task.resume()
  }
}
