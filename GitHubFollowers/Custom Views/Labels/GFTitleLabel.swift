//
//  GFTitleLabel.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 20/04/24.
//

import UIKit

class GFTitleLabel: UILabel {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
    super.init(frame: .zero)
    self.textAlignment = textAlignment
    self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    configure()
  }
  
  private func configure() {
    textColor = .label
    adjustsFontSizeToFitWidth = true
    // 0.9 - 90%
    minimumScaleFactor = 0.9
    // if the username is too long, it's just going to break it of by "...". paulhendric...
    lineBreakMode = .byTruncatingTail
    translatesAutoresizingMaskIntoConstraints = false
  }
  
}
