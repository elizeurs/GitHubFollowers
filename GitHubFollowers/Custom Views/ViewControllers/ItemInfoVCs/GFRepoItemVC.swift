//
//  GFRepoItemVC.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 22/05/24.
//

import UIKit

class GFRepoItemVC: GFItemInfoVC {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureItems()
  }
  
  private func configureItems() {
    itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
    itemInfoViewTwo.set(itemInfoType: .gist, withCount: user.publicGists)
    actionButton.set(backroundColor: .systemPurple, title: "GitHub Profile")
  }
  
  override func actionButtonTapped() {
    delegate.didTapGitHubProfile(for: user)
  }
}
