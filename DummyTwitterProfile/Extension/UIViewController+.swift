//
//  UIViewController+.swift
//  DummyTwitterProfile
//
//  Created by sakiyamaK on 2021/04/29.
//

import UIKit

extension UIViewController {
  func show(next: UIViewController, animated: Bool, present: Bool, completion: (() -> Void)? = nil) {
    if !present, let nav = self.navigationController {
      UIView.animate(withDuration: 0.0) {
        nav.pushViewController(next, animated: animated)
      } completion: { _ in
        completion?()
      }
    } else {
      self.present(next, animated: animated, completion: completion)
    }
  }

  func add(content: UIViewController, container: UIView){
    addChild(content)
    content.view.frame = container.bounds
    container.addSubview(content.view)
    content.didMove(toParent: self)
  }

  func remove(content: UIViewController){
    content.willMove(toParent: self)
    content.view.removeFromSuperview()
    content.removeFromParent()
  }
}
