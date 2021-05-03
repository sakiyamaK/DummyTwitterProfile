//
//  ProfileView.swift
//  DummyTwitterProfile
//
//  Created by  on 2021/4/28.
//

import UIKit

protocol ProfileView: AnyObject {
  func updateView(user: UserEntity, tweetsTuples: [(TweetType, [TweetEntity])])
  func updateScrollEnable(root: Bool, collection: Bool)
}

final class ProfileViewController: UIViewController {

  @IBOutlet weak var bigUserIconWidthConst: NSLayoutConstraint!
  @IBOutlet weak var bigUserIcon: UIImageView! {
    didSet {
      bigUserIcon.layer.cornerRadius = 32
      bigUserIcon.clipsToBounds = true
    }
  }
  @IBOutlet private weak var userIcon: UIImageView! {
    didSet {
      userIcon.layer.cornerRadius = 18
      userIcon.clipsToBounds = true
    }
  }
  @IBOutlet private weak var rootScrollView: UIScrollView!
  @IBOutlet private weak var tabScrollView: UIScrollView!
  @IBOutlet private weak var pageStackView: UIStackView!
  @IBOutlet private weak var tabButtonStackView: UIStackView!

  private var collectionViewController: ProfileCollectionViewController? {
    self.children.map { $0 as? ProfileCollectionViewController }.compactMap { $0 }.first
  }

  private var presenter: ProfilePresentation!
  func inject(presenter: ProfilePresentation) {
    self.presenter = presenter
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    presenter.viewDidLoad()
  }
}

extension ProfileViewController: ProfileView {
  func updateView(user: UserEntity, tweetsTuples: [(TweetType, [TweetEntity])]) {
    DispatchQueue.main.async {

      tweetsTuples.forEach { (tweetType, _) in

        let button = UIButton()
        button.setTitle(tweetType.keyName, for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.titleLabel?.textAlignment = .center
        self.tabButtonStackView.addArrangedSubview(button)

        let containerView = UIView()
        let vc = ProfileCollectionViewController.makeFromStoryboard()
        vc.delegate = self
        vc.inject(presenter: self.presenter, tweetType: tweetType)
        self.add(content: vc, container: containerView)

        self.pageStackView.addArrangedSubview(containerView)
        containerView.activate([
          containerView.widthAnchor.constraint(equalTo: self.tabScrollView.frameLayoutGuide.widthAnchor),
          containerView.heightAnchor.constraint(equalTo: self.tabScrollView.frameLayoutGuide.heightAnchor)
        ])

        vc.reloadData()
      }
    }
  }

  func updateScrollEnable(root: Bool, collection: Bool) {
    rootScrollView.isScrollEnabled = root
    self.children.map { $0 as? ProfileCollectionViewController }.compactMap { $0 }.forEach {
      $0.updateScrollEnable(collection: collection)
    }
  }
}

extension ProfileViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let size: CGFloat = 64.0 - (64.0 - 36.0) * min(max(scrollView.contentOffset.y, 0), 40.0) / 40.0
    bigUserIconWidthConst.constant = size
    bigUserIcon.layer.cornerRadius = size / 2
    bigUserIcon.layoutIfNeeded()

    bigUserIcon.isHidden = scrollView.contentOffset.y >= 40

    let collectionOffsetY: Float = Float((collectionViewController?.contentOffset ?? .zero).y)
    presenter.scrollChanged(rootOffsetY: Float(scrollView.contentOffset.y), collectionOffsetY: collectionOffsetY)
  }
}

extension ProfileViewController: ProfileCollectionViewControllerDelegate {
  func collectionViewDidScroll(_ scrollView: UIScrollView) {
    let rootOffsetY: Float = Float(rootScrollView.contentOffset.y)
    let collectionOffsetY: Float = Float(scrollView.contentOffset.y)
    presenter.scrollChanged(rootOffsetY: rootOffsetY, collectionOffsetY: collectionOffsetY)
  }
}
