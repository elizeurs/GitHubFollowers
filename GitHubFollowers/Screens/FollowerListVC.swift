//
//  FollowerListVCVC.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 19/04/24.
//

import UIKit

class FollowerListVC: UIViewController {
  
  var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()
      view.backgroundColor = .systemBackground
      navigationController?.navigationBar.prefersLargeTitles = true
      
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
      
      // new way
      NetworkManager.shared.getFollowers(for: username, page: 1) { result in
        
        switch result {
        case .success(let followers):
          print(followers)
        case .failure(let error):
          self.presentGFAlertOnMainThread(title: "Bad stuff happend", message: error.rawValue, buttonTitle: "Ok")
        }
      }
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // solve NavBar issue, when you try to swipe back(left to right) from FollowerListVC to SearchVC.
    navigationController?.setNavigationBarHidden(false, animated: true)
  }

}
