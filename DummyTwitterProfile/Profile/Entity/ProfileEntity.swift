//
//  ProfileEntity.swift
//  DummyTwitterProfile
//
//  Created by  on 2021/4/28.
//

import Foundation

struct UserEntity: Codable {
  var headerImageURLStr: String?
  var iconURLStr: String?
  var displayNameStr: String?
  var userNameStr: String?
  var description: String?

  enum CodingKeys: String, CodingKey {
    case headerImageURLStr = "header_image_url"
    case iconURLStr = "icon_url"
    case displayNameStr = "display_name"
    case userNameStr = "user_name"
    case description
  }

  static var sample: UserEntity {
    UserEntity(from: [
      "header_image_url": "https://picsum.photos/300/200?\(UUID().description)",
      "icon_url": "https://picsum.photos/50/50?\(UUID().description)",
      "user_name": "sakiyamaK",
      "display_name": "さっきーだよ",
      "description": "よろぴくねーーーーーー！！！！"
    ])!
  }
}
