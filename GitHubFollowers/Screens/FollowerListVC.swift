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
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // solve NavBar issue between FollowerListVC and SearchVC
    navigationController?.setNavigationBarHidden(false, animated: true)
  }

}
