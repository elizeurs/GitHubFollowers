//
//  FollowerListVCVC.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 19/04/24.
//

import UIKit

class FollowerListVC: GFDataLoadingVC {
  
  enum Section { case main }
  
  var username: String!
  var followers: [Follower] = []
  var filteredFollowers: [Follower] = []
  var page = 1
  var hasMoreFollowers = true
  var isSearching = false
  // prevent making a second call to the api, while scrolling and loading pagination.
  var isLoadingMoreFollowers = false
  
  var collectionView: UICollectionView!
  var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
  
  init(username: String) {
    super.init(nibName: nil, bundle: nil)
    self.username   = username
    title           = username
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    configureSearchController()
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
    
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    navigationItem.rightBarButtonItem = addButton
  }
  
  func configureCollectionView() {
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
    view.addSubview(collectionView)
    collectionView.delegate = self
    collectionView.backgroundColor = .systemBackground
    collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
  }
  
  func configureSearchController() {
    let searchController                                    = UISearchController()
    searchController.searchResultsUpdater                   = self
    searchController.searchBar.placeholder                  = "Search for a username"
    // to avoid that faint black overlay
    searchController.obscuresBackgroundDuringPresentation   = false
    navigationItem.searchController                         = searchController
  }
  
  func getFollowers(username: String, page: Int) {
    // new way
    /*ARC:
     [weak self] - Make self weak and anytime we make self weak, it's gonna be an optional.
     adding (?) will be the fix for this or unwrap the optional self (guard let self = self else {return).
     */
    showLoadingView()
    isLoadingMoreFollowers = true
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
        
        self.updateData(on: self.followers)
        
//        print(followers)
      case .failure(let error):
        self.presentGFAlertOnMainThread(title: "Bad stuff happend", message: error.rawValue, buttonTitle: "Ok")
      }
      
      self.isLoadingMoreFollowers = false
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
  
  func updateData(on followers: [Follower]) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
    // snapshot is the key for UICollectionViewDiffableDataSource. you have to pass those sections and items.
    snapshot.appendSections([.main])
    snapshot.appendItems(followers)
    DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
  }
  
  @objc func addButtonTapped() {
//    print("Add Button Tapped")
    
    showLoadingView()
    
    NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
      guard let self = self else { return }
      self.dismissLoadingView()
      
      switch result {
      case .success(let user):
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        
        PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
          guard let self = self else { return }
          
          guard let error = error else {
            self.presentGFAlertOnMainThread(title: "Success", message: "You have successfully favorited this user 🎉", buttonTitle: "Hooray!")
            return
          }
          
          self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
        }
      case .failure(let error):
        self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
      }
    }
  }
}

extension FollowerListVC: UICollectionViewDelegate {
  
  // for pagination
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    let height = scrollView.frame.size.height
    
    if offsetY >  contentHeight - height {
      guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
      page += 1
      getFollowers(username: username, page: page)
    }
    
//    print("OffsetY = \(offsetY)")
//    print("ContentHeight = \(contentHeight)")
//    print("Height = \(height)")
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // ternary operator - What ? True : False
    let activeArray     = isSearching ? filteredFollowers : followers
    let follower        = activeArray[indexPath.item]
    
    let destVC          = UserInfoVC()
    destVC.username     = follower.login
    destVC.delegate     = self
    let navController   = UINavigationController(rootViewController: destVC)
    present(navController, animated: true)
  }
}

extension FollowerListVC: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    // whatever that text is, that is our filter.
    guard let filter = searchController.searchBar.text, !filter.isEmpty else {
      filteredFollowers.removeAll()
      // go back to our initial follower state, when you delete the first letter of a name.
      updateData(on: followers)
      isSearching = false
      return
    }
    isSearching = true
    /* filter/map/reduce.
    $0 - represents an item.
     */
    filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased())}
    updateData(on: filteredFollowers)
  }
}

extension FollowerListVC: UserInfoVCDelegate {
  
  func didRequestFollowers(for username: String) {
    // get followers for that user
    // we are basically resetting the page and then making the network call again.
    self.username   = username
    title           = username
    page            = 1
    followers.removeAll()
    filteredFollowers.removeAll()
    // .zero - go up to the top. scroll up to the top real quick, if it's not.
//    collectionView.setContentOffset(.zero, animated: true)
    // correct bug when clicking on a follower, it takes you to the top of the list, but the first row is cut and showing only half.
    collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    getFollowers(username: username, page: page)
  }
}
