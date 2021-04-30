//
//  TweetEntity.swift
//  DummyTwitterProfile
//
//  Created by sakiyamaK on 2021/04/29.
//

import Foundation

struct TweetEntity: Codable {
  var user: UserEntity?
  var text: String?
  var doneRetweet: Bool?
  var doneLove: Bool?
  var imageURLStrs: [String]?

  enum CodingKeys: String, CodingKey {
    case user = "user"
    case text = "text"
    case doneRetweet = "done_retweet"
    case doneLove = "done_love"
    case imageURLStrs = "image_urls"
  }

  static var sample: Self {
    Self(from: [
//      "user": UserEntity.sample.jsonStr!,
      "text": "これはテキストでえええええす",
      "done_reteweet": false,
      "done_love": true,
      "image_urls": [
        "https://picsum.photos/300/300?\(UUID().description)",
        "https://picsum.photos/300/300?\(UUID().description)",
        "https://picsum.photos/300/300?\(UUID().description)"
      ]
    ])!
  }

}
