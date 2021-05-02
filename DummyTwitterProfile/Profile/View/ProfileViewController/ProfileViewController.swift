//
//  ProfileView.swift
//  DummyTwitterProfile
//
//  Created by  on 2021/4/28.
//

import UIKit

protocol ProfileView: AnyObject {
  func updateView(user: UserEntity, tweetsTuples: [(TweetType, [TweetEntity])])
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

  private var presenter: ProfilePresentation!
  func inject(presenter: ProfilePresentation) {
    self.presenter = presenter
  }

  //レイアウト
  var layout: UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )

    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .absolute(200)
    )

    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
    group.contentInsets = .init(top: 10, leading: 0, bottom: 10, trailing: 0)

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)

    let layout = UICollectionViewCompositionalLayout(section: section)

    return layout
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

      tweetsTuples.forEach { (tweetType, tweets) in

        let button = UIButton()
        button.setTitle(tweetType.keyName, for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.titleLabel?.textAlignment = .center
        self.tabButtonStackView.addArrangedSubview(button)

        let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: self.layout)
        collectionView.backgroundColor = .white
        collectionView.tag = tweetType.rawValue
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.description())

        self.pageStackView.addArrangedSubview(collectionView)
        collectionView.activate([
          collectionView.widthAnchor.constraint(equalTo: self.tabScrollView.frameLayoutGuide.widthAnchor),
          collectionView.heightAnchor.constraint(equalTo: self.tabScrollView.frameLayoutGuide.heightAnchor)
        ])
      }

      self.pageStackView.arrangedSubviews.map {$0 as? UICollectionView }.compactMap { $0 }.forEach {
        $0.reloadData()
      }

    }
  }

}
extension ProfileViewController: UICollectionViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == rootScrollView {
      let size: CGFloat = 64 - (64.0 - 36.0) * fabs(min(scrollView.contentOffset.y, 40) / 40.0)
      bigUserIconWidthConst.constant = size
      bigUserIcon.layer.cornerRadius = size/2
      bigUserIcon.layoutIfNeeded()

      bigUserIcon.isHidden = scrollView.contentOffset.y >= 40
    }
  }
}

extension ProfileViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    presenter.tweetsTuples[collectionView.tag].1.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.description(), for: indexPath)
    switch collectionView.tag {
    case TweetType.myTweet.rawValue:
      cell.backgroundColor = .systemRed
    case TweetType.lovedTweet.rawValue:
      cell.backgroundColor = .systemBlue
    case TweetType.mediaTweet.rawValue:
      cell.backgroundColor = .systemPink
    case TweetType.replayTweet.rawValue:
      cell.backgroundColor = .systemTeal
    default:
      break
    }
    return cell
  }
}
