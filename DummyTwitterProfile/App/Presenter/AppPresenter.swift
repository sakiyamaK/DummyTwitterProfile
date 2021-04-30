//
//  AppPresentation.swift
//  DummyTwitterProfile
//
//  Created by  on 2021/4/29.
//

import Foundation

protocol AppPresentation: AnyObject {
  func didFinishLaunch()
}

final class AppPresenter {
  private let router: AppWireframe
  private let interactor: AppUsecase

  init(
    interactor: AppUsecase,
    router: AppWireframe
  ) {
    self.interactor = interactor
    self.router = router
  }
}

extension AppPresenter: AppPresentation {
  func didFinishLaunch() {
    self.router.showProfile()
  }
}
