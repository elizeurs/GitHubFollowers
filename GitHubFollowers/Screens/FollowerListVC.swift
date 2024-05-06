//
//  FollowerListVCVC.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 19/04/24.
//

import UIKit

enum Section {
  case main
}

class FollowerListVC: UIViewController {
  
  var username: String!
  var followers: [Follower] = []
  
  var collectionView: UICollectionView!
  var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    configureCollectionView()
    getFollowers()
    configureDataSource()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // solve NavBar issue, when you try to swipe back(left to right) from FollowerListVC to SearchVC.
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  func configureViewController() {
    view.backgroundColor = .systemBackground
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  func configureCollectionView() {
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createThreeColumnFlowLayout())
    view.addSubview(collectionView)
    collectionView.backgroundColor = .systemBackground
    collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
  }
  
  func createThreeColumnFlowLayout() -> UICollectionViewFlowLayout {
    let width                         = view.bounds.width
    let padding: CGFloat              = 12
    let minimunItemSpacing: CGFloat   = 10
    let availableWidth                = width - (padding * 2) - (minimunItemSpacing * 2)
    let itemWidth                     = availableWidth / 3
    
    let flowLayout                    = UICollectionViewFlowLayout()
    flowLayout.sectionInset           = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    flowLayout.itemSize               = CGSize(width: itemWidth, height: itemWidth + 40)
    
    return flowLayout
  }
  
  func getFollowers() {
    // new way
    NetworkManager.shared.getFollowers(for: username, page: 1) { result in
      
      switch result {
      case .success(let followers):
        self.followers = followers
        self.updateData()
//        print(followers)
      case .failure(let error):
        self.presentGFAlertOnMainThread(title: "Bad stuff happend", message: error.rawValue, buttonTitle: "Ok")
      }
    }
  }
  /*
   // old way:
   NetworkManager.shared.getFollowers(for: username, page: 1) { followers, errorMessage in
   guard let followers = followers else {
   self.presentGFAlertOnMainThread(title: "Bad Stuff Happend", message: errorMessage!.rawValue, buttonTitle: "Ok")
   return
   }
   
   print("Followers.count = \(followers.count)")
   print(followers)
   }
   */
  
  
  // MARK: UICollectionViewDiffableDataSource
  
  func configureDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
      cell.set(follower: follower)
      return cell
    })
  }
  
  func updateData() {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
    // snapshot is the key for UICollectionViewDiffableDataSource. you have to pass those sections and items.
    snapshot.appendSections([.main])
    snapshot.appendItems(followers)
    DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
  }
  
}
