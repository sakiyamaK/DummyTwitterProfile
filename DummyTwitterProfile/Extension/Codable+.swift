//
//  Decodable+.swift
//  DummyTwitterProfile
//
//  Created by sakiyamaK on 2021/04/30.
//

import Foundation

extension Decodable {
  init?(from: [String: Any]) {
    guard let jsonData = try? JSONSerialization.data(withJSONObject: from, options: []),
          let decoded = try? JSONDecoder().decode(Self.self, from: jsonData) else {
      return nil
    }
    self = decoded
  }
}

extension Encodable {
  var jsonStr: String? {
    guard let jsonData = try? JSONEncoder().encode(self),
          let jsonStr = String.init(data: jsonData, encoding: .utf8) else {
      return nil
    }
    return jsonStr
  }
}
