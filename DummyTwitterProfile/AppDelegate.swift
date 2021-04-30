//
//  AppDelegate.swift
//  DummyTwitterProfile
//
//  Created by sakiyamaK on 2021/04/28.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  let appPresenter = AppRouter.assembleModules(window: UIWindow(frame: UIScreen.main.bounds))

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    appPresenter.didFinishLaunch()
    return true
  }
}

