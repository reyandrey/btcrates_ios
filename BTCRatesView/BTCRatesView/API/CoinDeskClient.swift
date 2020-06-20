//
//  CoinDeskClient.swift
//  BTCRatesView
//
//  Created by Andrey on 12.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

fileprivate typealias API = CoinDeskAPI
fileprivate typealias JSONObject = [String: Any]

class CoinDeskClient: HTTPClient {
    private let log = Log<CoinDeskClient>()
    override var httpHeaders: [String : String] {
        var h = [String: String]()
        h["Accept"] = "application/json"
        h["Content-Type"] = "application/json"
        return h
    }
}

// API

extension CoinDeskClient {
    func getCurrencies(completionHandler: @escaping ([Currency]?) -> Void) {
        request(to: CoinDeskAPI.currencies) { result in
            switch result {
            case .success(let data):
                completionHandler(try? JSONDecoder().decode([Currency].self, from: data ?? Data()))
            case .failure(let error):
                self.log.error("\(error)")
            }
        }
    }
    
    func getWeekHistory(currency: String, completionHandler: @escaping ([BPIHistory.Rate]?) -> ()) {
        getHistory(code: currency, period: .week) { history in
            self.getCurrentPrice(code: currency) { realtime in
                guard let h = history, let n = realtime?.rateDouble else { completionHandler(nil); return }
                var result = [BPIHistory.Rate]()
                result.append(contentsOf: h.data)
                result.append(BPIHistory.Rate(date: Date(), value: n))
                completionHandler(result)
            }
        }
    }
    
}

private extension CoinDeskClient {
    
    func getCurrentPrice(code: String, completionHandler: @escaping (BPIRealTime?) -> Void) {
        request(to: API.currentPrice(code: code)) { result in
            switch result {
            case .failure(_): completionHandler(nil)
            case .success(let data):
                guard let data = data else { completionHandler(nil); return }
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? JSONObject else { completionHandler(nil); return }
                guard let bpiJSON = json["bpi"] as? JSONObject else { completionHandler(nil); return }
                guard let requestedBPI = bpiJSON[code] else { completionHandler(nil); return }
                guard let bpiData = try? JSONSerialization.data(withJSONObject: requestedBPI, options: []) else { completionHandler(nil); return }
                completionHandler(try? JSONDecoder().decode(BPIRealTime.self, from: bpiData))
            }
        }
    }
    
    func getHistory(code: String, period: BPIHistory.Period, completionHandler: @escaping (BPIHistory?) -> Void) {
        request(to: API.historical(code: code, start: period.startDate, end: period.endDate)) { result in
            switch result {
            case .success(let data):
                completionHandler(try! BPIHistory(from: data ?? Data()))
            case .failure(let error):
                self.log.error("\(error)")
                completionHandler(nil)
            }
        }
    }
    
}
