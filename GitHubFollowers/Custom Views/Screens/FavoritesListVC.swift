//
//  FavoritesListVC.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 16/04/24.
//

import UIKit

class FavoritesListVC: UIViewController {
  
  let tableView               = UITableView()
  var favorites: [Follower]   = []

    override func viewDidLoad() {
        super.viewDidLoad()
      configureViewController()
      configureTableView()
    }

  // viewDidLoad is called only once. If the user navigates to their favorites and sees no favorites,
  // then switches to the follower list screen, adds a favorite, and returns, viewDidLoad won't be called again.
  // Therefore, viewWillAppear will be called instead. We need to call getFavorites in viewWillAppear
  // to ensure that the favorites list is refreshed, even if new favorites are added mid-session.
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getFavorites()
  }
  
  func configureViewController() {
    view.backgroundColor = .systemBackground
    title                = "Favorites"
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  func configureTableView() {
    view.addSubview(tableView)
    
    // fill up the whole view.
    tableView.frame         = view.bounds
    tableView.rowHeight     = 80
    tableView.delegate      = self
    tableView.dataSource    = self
    
    tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
  }
  
  func getFavorites() {
    PersistenceManager.retrieveFavorites { [weak self] result in
      guard let self = self else { return }
      
      switch result {
      case .success(let favorites):
//        print(favorites)
        if favorites.isEmpty {
          self.showEmptyStateView(with: "No favorites?\nAdd one on the follower screen.", in: self.view)
        } else {
          self.favorites = favorites
          // reloading table on a tableView, you have to do that on the main thread.
          DispatchQueue.main.async {
            self.tableView.reloadData()
            // just in case, the empty state gets populated on top of it.
            self.view.bringSubviewToFront(self.tableView)
          }
        }

      case .failure(let error):
        self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
      }
    }
  }
}

extension FavoritesListVC: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favorites.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell
    let favorite = favorites[indexPath.row]
    cell.set(favorite: favorite)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let favorite      = favorites[indexPath.row]
    let destVC        = FollowerListVC()
    destVC.username   = favorite.login
    destVC.title      = favorite.login
    
    navigationController?.pushViewController(destVC, animated: true)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else { return }
    
    let favorite = favorites[indexPath.row]
    favorites.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .left)
    
    PersistenceManager.updateWith(favorite: favorite, actionType: .remove) { [weak self] error in
      guard let self = self else { return }
      guard let error = error else { return }
      self.presentGFAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
    }
  }
}
