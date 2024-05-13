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
  var page = 1
  var hasMoreFollowers = true
  
  var collectionView: UICollectionView!
  var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    configureCollectionView()
    getFollowers(username: username, page: page)
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
    collectionView.delegate = self
    collectionView.backgroundColor = .systemBackground
    collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
  }
  
  func getFollowers(username: String, page: Int) {
    // new way
    /*ARC:
     [weak self] - Make self weak and anytime we make self weak, it's gonna be an optional.
     adding (?) will be the fix for this or unwrap the optional self (guard let self = self else {return).
     */
    showLoadingView()
    NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
      // use #warnig("") instead of to-dos, in order to come back and fix this.
      // #warning("Call Dismiss") - done already.
      // unwrapping the optional self
      guard let self = self else { return }
      self.dismissLoadingView()
      
      switch result {
      case .success(let followers):
        if followers.count < 100 { self.hasMoreFollowers = false }
        // so it keeps appending more followers to the list.
        self.followers.append(contentsOf: followers)
        
        if self.followers.isEmpty {
          let message = "This user doesn't have any followers. Go follow them 😀."
          /*
           self - we're in a closure.
           we are on a background thread. anytime we're updating or presenting an UI, we have to go on the main queue here.
          */
          DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
          // return - if we're showing the empty state view, we want to get out of here, like, we want nothing else to execute. we don't want to call updateData, if that happens.
          return
        }
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

extension FollowerListVC: UICollectionViewDelegate {
  
  // for pagination
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    let height = scrollView.frame.size.height
    
    if offsetY >  contentHeight - height {
      guard hasMoreFollowers else { return }
      page += 1
      getFollowers(username: username, page: page)
    }
    
//    print("OffsetY = \(offsetY)")
//    print("ContentHeight = \(contentHeight)")
//    print("Height = \(height)")
  }
}