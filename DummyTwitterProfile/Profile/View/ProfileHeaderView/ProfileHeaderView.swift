//
//  ProfileHeaderView.swift
//  DummyTwitterProfile
//
//  Created by sakiyamaK on 2021/04/29.
//

import UIKit

final class ProfileHeaderView: UIView {
  
  @IBOutlet private weak var navigationBottom: UIView!
  @IBOutlet private weak var headerImageView: UIImageView!
  @IBOutlet private weak var bottomBarContainerView: UIView!

  func addConstraint(view: UIView) {
    navigationBottom.activate([
      navigationBottom.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor)
    ])
    bottomBarContainerView.activate([
      bottomBarContainerView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor)
    ])
  }

  func configure(user: UserEntity) {

  }
}
