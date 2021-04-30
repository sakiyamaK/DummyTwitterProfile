//
//  ProfilePresentation.swift
//  DummyTwitterProfile
//
//  Created by  on 2021/4/28.
//

import Foundation

protocol ProfilePresentation: AnyObject {
  func viewDidLoad()
  var tweetsTuples: [(TweetType, [TweetEntity])] { get }
}

final class ProfilePresenter {
  private weak var view: ProfileView?
  private let router: ProfileWireframe
  private let interactor: ProfileUsecase

  init(
    view: ProfileView,
    interactor: ProfileUsecase,
    router: ProfileWireframe
  ) {
    self.view = view
    self.interactor = interactor
    self.router = router
  }
}

extension ProfilePresenter: ProfilePresentation {
  var tweetsTuples: [(TweetType, [TweetEntity])] { interactor.tweetsTuples }

  func viewDidLoad() {
    let group = DispatchGroup()

    var user: UserEntity = .init()
    var tweetsTuples = [(TweetType, [TweetEntity])]()
    var errors = [APIError]()

    group.enter()
    interactor.getUser(userId: 0) { result in
      switch result {
      case .failure(let error):
        errors.append(error)
        group.leave()
      case .success(let responseUser):
        user = responseUser
        group.leave()
      }
    }

    group.enter()
    interactor.getTweetsDic(userId: 0, completion: { result in
      switch result {
      case .failure(let error):
        errors.append(error)
        group.leave()
      case .success(let responseTweetsTuples):
        tweetsTuples = responseTweetsTuples
        group.leave()
    }
    })

    group.notify(queue: DispatchQueue.global(qos: .default)) { [unowned self] in
      if let error = errors.first {
        self.router.show(error: error)
      } else {
        self.view?.updateView(user: user, tweetsTuples: tweetsTuples)
      }
    }
  }
}
