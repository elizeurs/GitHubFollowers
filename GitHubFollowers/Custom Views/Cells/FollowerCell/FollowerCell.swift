//
//  FollowerCell.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 30/04/24.
//

import UIKit
import SwiftUI

class FollowerCell: UICollectionViewCell {
  
  // static - because of that, i can access it on FollowerListVC
  static let reuseID = "FollowerCell"
  // .zero - we're going to be adjusting all this via constraints.
  let avatarImageView   = GFAvatarImageView(frame: .zero)
  let usernameLabel     = GFTitleLabel(textAlignment: .center, fontSize: 16)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func set(follower: Follower) {
    // UIHostingConfiguration - new thing in iOS 16.
    if #available(iOS 16.0, *) {
      contentConfiguration = UIHostingConfiguration { FollowerView(follower: follower) }
    } else {
      // Fallback on earlier versions
      avatarImageView.downloadImage(fromURL: follower.avatarUrl)
      usernameLabel.text = follower.login
    }
  }
  
  private func configure() {
    addSubviews(avatarImageView, usernameLabel)
    
    let padding: CGFloat = 8
    
    NSLayoutConstraint.activate([
      avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
      avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
      avatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
      avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
      
      usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
      usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
      usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
      usernameLabel.heightAnchor.constraint(equalToConstant: 20)
    ])
  }
}
