//
//  ProfileCollectionViewController.swift
//  DummyTwitterProfile
//
//  Created by  on 2021/5/3.
//

import UIKit

protocol ProfileCollectionViewControllerDelegate: AnyObject {
  func collectionViewDidScroll(_ scrollView: UIScrollView)
}

final class ProfileCollectionViewController: UIViewController {

  @IBOutlet private weak var collectionView: UICollectionView! {
    didSet {
      collectionView.collectionViewLayout = layout
      collectionView.backgroundColor = .white
      collectionView.dataSource = self
      collectionView.delegate = self
      collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.description())
    }
  }

  static func makeFromStoryboard() -> ProfileCollectionViewController {
    UIStoryboard(name: "ProfileCollection", bundle: nil).instantiateInitialViewController() as! ProfileCollectionViewController
  }

  private var presenter: ProfilePresentation!
  private var tweetType: TweetType!
  func inject(presenter: ProfilePresentation, tweetType: TweetType) {
    self.presenter = presenter
    self.tweetType = tweetType
  }

  var contentOffset: CGPoint { collectionView.contentOffset }
  weak var delegate: ProfileCollectionViewControllerDelegate?

  var tweets: [TweetEntity] {
    presenter.tweetsTuples.filter { $0.0 == tweetType }.first?.1 ?? []
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

  func reloadData() {
    collectionView.reloadData()
  }

  func updateScrollEnable(collection: Bool) {
    collectionView.isScrollEnabled = collection
  }
}


extension ProfileCollectionViewController: UICollectionViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    delegate?.collectionViewDidScroll(scrollView)
  }
}

extension ProfileCollectionViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    tweets.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.description(), for: indexPath)
    switch tweetType {
    case .myTweet:
      cell.backgroundColor = .systemRed
    case .lovedTweet:
      cell.backgroundColor = .systemBlue
    case .mediaTweet:
      cell.backgroundColor = .systemGreen
    case .replayTweet:
      cell.backgroundColor = .systemTeal
    default:
      break
    }
    return cell
  }
}
