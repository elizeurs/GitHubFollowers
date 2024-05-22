//
//  GFFollowerItemVC.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 22/05/24.
//

import UIKit

class GFFollowerItemVC: GFItemInfoVC {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureItems()
  }
  
  private func configureItems() {
    itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
    itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
    actionButton.set(backroundColor: .systemGreen, title: "Get Followers")
  }
}
