//
//  CoinDeskClient.swift
//  BTCRatesView
//
//  Created by Andrey on 12.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation
import CoreData

fileprivate typealias API = CoinDeskAPI

class CoinDeskClient: HTTPClient {
  private let syncContext: NSManagedObjectContext = CoreDataStack.shared.getPrivateContext(automaticallyMergesChangesFromParent: true)
  
  private let log = Log<CoinDeskClient>()
  
  private lazy var jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    decoder.userInfo[.managedObjectContext] = self.syncContext
    return decoder
  }()
  
  override var httpHeaders: [String : String] {
    var h = [String: String]()
    h["Accept"] = "application/json"
    h["Content-Type"] = "application/json"
    return h
  }
}

// API

extension CoinDeskClient {
  func syncCurrencies(completionHandler: @escaping (Error?) -> Void) {
    request(to: CoinDeskAPI.currencies) { result in
      switch result {
      case .success(let data):
        guard let currencies = try? self.jsonDecoder.decode([CurrencyModel].self, from: data ?? Data()) else {
                completionHandler(HTTPClient.ErrorType.missingResponse)
                return
        }
        self.syncContext.performAndWait {
          self.syncObjects(currencies, dropMissing: true)
          self.saveData {
            completionHandler(nil)
          }
        }
      case .failure(let error):
        self.log.error("\(error)")
        completionHandler(error)
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
  
  func getYearHistory(currency: String, completionHandler: @escaping ([BPIHistory.Rate]?) -> ()) {
    getHistory(code: currency, period: .year) { history in
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

// MARK: Privatec

private extension CoinDeskClient {
  func getCurrentPrice(code: String, completionHandler: @escaping (BPIRealTime?) -> Void) {
    request(to: API.currentPrice(code: code)) { result in
      switch result {
      case .failure(_): completionHandler(nil)
      case .success(let data):
        guard let data = data,
              let currency = try? JSON(data: data)["bpi"][code].rawData()
          else { completionHandler(nil); return }
        completionHandler(try? self.jsonDecoder.decode(BPIRealTime.self, from: currency))
      }
    }
  }
  
  func getHistory(code: String, period: BPIHistory.Period, completionHandler: @escaping (BPIHistory?) -> Void) {
    request(to: API.historical(code: code, start: period.startDate, end: period.endDate)) { result in
      switch result {
      case .success(let data):
        completionHandler(try? BPIHistory(with: data ?? Data()))
      case .failure(let error):
        self.log.error("\(error)")
        completionHandler(nil)
      }
    }
  }
}

// MARK: Core Data Sync

private extension CoinDeskClient {
  func syncObjects<ObjectType: NSManagedObject&ManagedSyncable>(_ objects: [ObjectType], dropMissing: Bool = true) {
    syncContext.perform {
      do {
        if dropMissing {
          try ObjectType.dropMissing(objects, in: self.syncContext)
        }
        try ObjectType.syncObjects(objects, in: self.syncContext)
        self.log.debug("Objects synced: " + String(describing: ObjectType.self))
      } catch {
        self.log.error("Failed to sync objects of type: " + String(describing: ObjectType.self))
      }
    }
  }
  
  func saveData(onCompletion completionHandler: @escaping ()->()) {
    syncContext.perform {
      if self.syncContext.hasChanges {
        do {
          try self.syncContext.save()
          CoreDataStack.shared.saveChanges()
          completionHandler()
        } catch {
          self.log.error("Failed to save context: \(error)")
          completionHandler()
        }
      } else {
        completionHandler()
      }
    }
  }
}
