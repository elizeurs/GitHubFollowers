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
  
  convenience init(color: UIColor, title: String, systemImageName: String) {
    self.init(frame: .zero)
    set(color: color, title: title, systemImageName: systemImageName)
//    self.backgroundColor = backgroundColor
//    self.setTitle(title, for: .normal)
  }
  
  // private - this func can only be called in this class GFButton.
  // Apple has proposed a new method for creating UIButtons.
  private func configure() {
    configuration = .tinted()
    configuration?.cornerStyle = .medium
    translatesAutoresizingMaskIntoConstraints = false
//    layer.cornerRadius      = 10
    // Dynamic Type - allow the user change font size on the phone. and for this, you use .preferreddFont(forTextStyle: UIFont.TextStyle).
//    titleLabel?.font        = UIFont.preferredFont(forTextStyle: .headline)
//    setTitleColor(.white, for: .normal)
    // it allows you to use auto layout, when you're doing layout programmatically
    // TAMIC
  }
  
  // Apple has proposed a new method for creating UIButtons.
  func set(color: UIColor, title: String, systemImageName: String) {
    configuration?.baseBackgroundColor = color
    configuration?.baseForegroundColor = color
    configuration?.title = title
//    self.backgroundColor = backroundColor
//    setTitle(title, for: .normal)
    
    configuration?.image = UIImage(systemName: systemImageName)
    configuration?.imagePadding = 6
    configuration?.imagePlacement = .leading
  }
  
}
