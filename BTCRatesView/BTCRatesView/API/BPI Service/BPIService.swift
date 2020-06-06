//
//  BPIService.swift
//  BTCRatesView
//
//  Created by Andrey Fokin on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

fileprivate typealias JSONObject = [String:Any]

class BPIService<E: Environment>: APIService {
    static var serverURL: String { return E.serverURL }
    static var defaultHTTPHeaders: [String : String] {
        var h = [String: String]()
        h["Accept"] = "application/json"
        h["Content-Type"] = "application/json"
        return h
    }
    
    private lazy var httpManager: HTTPRequestManager = { HTTPRequestManager(defaultHeaders: BPIService.defaultHTTPHeaders) }()
    
    init() {}
    
    
    func getURL(for endpoint: APIEndpoint) throws -> URL {
        guard let url = URL(string: E.serverURL.appending(endpoint.path)) else { throw APIServiceError.invalidURLError }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = endpoint.queryItems
        if let components = components, let url = components.url { return url }
        else { throw APIServiceError.invalidURLError }
    }
}

extension BPIService {
    
    func getSupportedCurrencies(completionHandler: @escaping ([Currency]?) -> Void) {
        let url = try! getURL(for: BPIEndpint.currencies)
        httpManager.sendRequest(.get, to: url, withPayload: nil) { (data, response, error) in
            if error == nil, let data = data {
                completionHandler(try? JSONDecoder().decode([Currency].self, from: data))
            } else {
                completionHandler(nil)
            }
        }
    }
    
    func getCurrentPrice(code: String, completionHandler: @escaping (BPIRealTime?) -> Void) {
        let url = try! getURL(for: BPIEndpint.currentPrice(code: code))
        httpManager.sendRequest(.get, to: url, withPayload: nil) { (data, response, error) in
            guard let data = data else { completionHandler(nil); return }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? JSONObject else { completionHandler(nil); return }
            guard let bpiJSON = json["bpi"] as? JSONObject else { completionHandler(nil); return }
            guard let requestedBPI = bpiJSON[code] else { completionHandler(nil); return }
            guard let bpiData = try? JSONSerialization.data(withJSONObject: requestedBPI, options: []) else { completionHandler(nil); return }
            completionHandler(try? JSONDecoder().decode(BPIRealTime.self, from: bpiData))
        }
    }
    
}
