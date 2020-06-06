//
//  APIService.swift
//  Forismatic
//
//  Created by Andrey on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

enum APIServiceError: Error {
    case clientError(code: Int)
    case serverError(code: Int)
    case networkError(error: Error)
    case invalidURLError
    case other
}

protocol APIService {
    func getURL(for endpoint: APIEndpoint) throws -> URL
}

protocol APIEndpoint {
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
}
