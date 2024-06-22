//
//  GFRepoItemVC.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 22/05/24.
//

import UIKit

protocol GFRepoItemVCDelegate: AnyObject {
  func didTapGitHubProfile(for user: User)
}

class GFRepoItemVC: GFItemInfoVC {
  
  // anytime you're dealing with the delegates, they need to be weak, so you can avoid the retain cycle.
  weak var delegate: GFRepoItemVCDelegate!
  
   init(user: User, delegate: GFRepoItemVCDelegate) {
    super.init(user: user)
    self.delegate = delegate
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureItems()
  }
  
  private func configureItems() {
    itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
    itemInfoViewTwo.set(itemInfoType: .gist, withCount: user.publicGists)
    actionButton.set(color: .systemPurple, title: "GitHub Profile", systemImageName: "person")
  }
  
  override func actionButtonTapped() {
    delegate.didTapGitHubProfile(for: user)
  }
}
