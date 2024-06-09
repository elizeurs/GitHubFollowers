//
//  GFTitleLabel.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 20/04/24.
//

import UIKit

class GFTitleLabel: UILabel {
  
  // designated initializer
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // convenience initializer - no need to call configure() here as well.
  convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
    self.init(frame: .zero)
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
