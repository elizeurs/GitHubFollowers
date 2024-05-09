//
//  FollowerListVCVC.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 19/04/24.
//

import UIKit

enum Section { case main }

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
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
    view.addSubview(collectionView)
    collectionView.backgroundColor = .systemBackground
    collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
  }
  
  func getFollowers() {
    // new way
    /*ARC:
     [weak self] - Make self weak and anytime we make self weak, it's gonna be an optional.
     adding (?) will be the fix for this or unwrap the optional self (guard let self = self else {return).
     */
    NetworkManager.shared.getFollowers(for: username, page: 1) { [weak self] result in
      // unwrapping the optional self
      guard let self = self else { return }
      
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
