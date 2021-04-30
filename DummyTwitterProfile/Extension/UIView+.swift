//
//  UIView+.swift
//  DummyTwitterProfile
//
//  Created by sakiyamaK on 2021/04/29.
//

import UIKit

extension UIView {
  func activate(_ constraints: [NSLayoutConstraint]) {
    self.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(constraints)
  }

  func edgesEqual(to: UIView) {
    self.activate([
      self.topAnchor.constraint(equalTo: to.topAnchor),
      self.leadingAnchor.constraint(equalTo: to.leadingAnchor),
      to.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      to.trailingAnchor.constraint(equalTo: self.trailingAnchor)
    ])
  }

  func edgesEqualToSpuerView() {
    guard let superview = self.superview else { return }
    self.edgesEqual(to: superview)
  }
}
