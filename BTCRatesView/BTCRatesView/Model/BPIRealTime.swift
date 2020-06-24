//
//  BPIRealTime.swift
//  BTCRatesView
//
//  Created by Andrey Fokin on 06.06.2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

class BPIRealTime: Decodable, CustomDecodable {
  let code: String
  let rate: String
  let description: String
  let rateDouble: Double
  
  
  // MARK: Codable
  
  private enum CodingKeys: String, CodingKey {
    case code
    case rate
    case description
    case rate_float
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.code = try container.decode(String.self, forKey: .code)
    self.rate = try container.decode(String.self, forKey: .rate)
    self.description = try container.decode(String.self, forKey: .description)
    self.rateDouble = try container.decode(Double.self, forKey: .rate_float)
  }
  
  // MARK: CustomDecodable
  
  required init(with data: Data) throws {
    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    let bpiJSON = json?["bpi"] as? JSONObject
    let bpiData = try JSONSerialization.data(withJSONObject: bpiJSON ?? [:], options: [])
    
    var decodedObjects = try JSONDecoder().decode([BPIRealTime].self, from: bpiData)
    if decodedObjects.count > 1 { decodedObjects = decodedObjects.filter { $0.code != "USD" } }
    guard let object = decodedObjects.first else { throw "init(with data: Data) failed" }
    
    code = object.code
    rate = object.rate
    description = object.description
    rateDouble = object.rateDouble
  }
  
}
