//
//  ProfileInteractor.swift
//  DummyTwitterProfile
//
//  Created by  on 2021/4/28.
//

import Foundation

enum TweetType: Int, CaseIterable {
  case myTweet = 0, replayTweet, mediaTweet, lovedTweet

  var keyName: String {
    switch self {
    case .myTweet:
      return "ツイート"
    case .replayTweet:
      return "ツイートと返信"
    case .mediaTweet:
      return "メディア"
    case .lovedTweet:
      return "いいね"
    }
  }

  var endPoint: String {
    ""
  }

  var error: APIError {
    switch self {
    case .myTweet:
      return APIError.getMyTweets
    case .replayTweet:
      return APIError.getReplyTweets
    case .mediaTweet:
      return APIError.getMediaTweets
    case .lovedTweet:
      return APIError.getLovedTweets
    }
  }

  func getTweets(userId: Int, completion: ((Result<[TweetEntity], APIError>) -> Void)?) {
    let tweets = (0...100).map { _ in
      TweetEntity.sample
    }
    completion?(.success(tweets))
  }
}

protocol ProfileUsecase {
  var tweetTypes: [TweetType] { get }
  var tweetsTuples: [(TweetType, [TweetEntity])] { get }
  func getUser(userId: Int, completion: ((Result<UserEntity, APIError>) -> Void)?)
  func getTweetsDic(userId: Int, completion: ((Result<[(TweetType, [TweetEntity])], APIError>) -> Void)?)
}

final class ProfileInteractor {
  private (set) var tweetsTuples: [(TweetType, [TweetEntity])] = .init()

  init() {
  }
}

extension ProfileInteractor: ProfileUsecase {
  var tweetTypes: [TweetType] { TweetType.allCases }

  func getUser(userId: Int, completion: ((Result<UserEntity, APIError>) -> Void)?) {
    let user = UserEntity.sample
    completion?(.success(user))
  }

  func getTweetsDic(userId: Int, completion: ((Result<[(TweetType, [TweetEntity])], APIError>) -> Void)?) {
    var tweetsTuples = [(TweetType, [TweetEntity])]()
    var errors = [APIError]()
    tweetTypes.enumerated().forEach { (index, tweetType) in
      tweetType.getTweets(userId: userId) { result in
        switch result {
        case .success(let tweetsTuple):
          tweetsTuples.append((tweetType, tweetsTuple))
        case .failure(let error):
          errors.append(error)
        }

        if index == self.tweetTypes.count - 1 {
          if let error = errors.first {
            completion?(.failure(error))
          } else {
            self.tweetsTuples = tweetsTuples
            completion?(.success(tweetsTuples))
          }
        }
      }
    }

  }
}

enum APIError: Error {
  case getUser, getMyTweets, getReplyTweets, getMediaTweets, getLovedTweets

  var title: String { "通信エラー" }
  var message: String { self.localizedDescription }
}
