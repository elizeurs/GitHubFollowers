//
//  GFButton.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 17/04/24.
//

import UIKit

class GFButton: UIButton {

  override init(frame: CGRect) {
    // super - call the super class or the parent. everything apple built into the default ui button, happens first and then we create our gfbutton.
    super.init(frame: frame)
    configure()
  }
  
  // we have 2 initializers. the coder one, when you initialize this gf button via storyboard, but we're not using storyboard, that's why we add fatalError.
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init(backgroundColor: UIColor, title: String) {
    super.init(frame: .zero)
    self.backgroundColor = backgroundColor
    self.setTitle(title, for: .normal)
    configure()
  }
  
  // private - this func can only be called in this class GFButton.
  private func configure() {
    layer.cornerRadius      = 10
    setTitleColor(.white, for: .normal)
    // Dynamic Type - allow the user change font size on the phone. and for this, you use .preferreddFont(forTextStyle: UIFont.TextStyle).
    titleLabel?.font        = UIFont.preferredFont(forTextStyle: .headline)
    // it allows you to use auto layout, when you're doing layout programmatically
    translatesAutoresizingMaskIntoConstraints = false
  }
  
}
