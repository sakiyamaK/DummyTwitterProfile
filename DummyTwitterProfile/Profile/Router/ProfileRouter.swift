//
//  ProfileRouter.swift
//  DummyTwitterProfile
//
//  Created by  on 2021/4/28.
//

import UIKit

protocol ProfileWireframe: AnyObject {
  func show(error: Error)
}

final class ProfileRouter {
  private unowned let viewController: UIViewController

  private init(viewController: UIViewController) {
    self.viewController = viewController
  }

  static func assembleModules() -> UIViewController {
    let view = UIStoryboard.loadProfile()
    let interactor = ProfileInteractor()
    let router = ProfileRouter(viewController: view)
    let presenter = ProfilePresenter(
      view: view,
      interactor: interactor,
      router: router
    )
    view.inject(presenter: presenter)
    return view
  }
}

extension ProfileRouter: ProfileWireframe {

  func show(error: Error) {
    let alertVC = UIAlertController()
    let okButton = UIAlertAction(title: "OK", style: .default) { _ in

    }
    alertVC.addAction(okButton)
    alertVC.message = error.localizedDescription
    viewController.present(alertVC, animated: true, completion: nil)
  }
}

extension UIStoryboard {
  static func loadProfile() -> ProfileViewController {
    UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController() as! ProfileViewController 
  }
}
