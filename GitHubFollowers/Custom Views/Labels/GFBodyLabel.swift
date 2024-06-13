//
//  GFBodyLabel.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 20/04/24.
//

import UIKit

class GFBodyLabel: UILabel {

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init(textAlignment: NSTextAlignment) {
    self.init(frame: .zero)
    self.textAlignment = textAlignment
  }
  
  private func configure() {
    textColor                                 = .secondaryLabel
    font                                      = UIFont.preferredFont(forTextStyle: .body)
    // implement Dynamic type.
    adjustsFontForContentSizeCategory         = true
    adjustsFontSizeToFitWidth                 = true
    // 0.75 - 75%
    minimumScaleFactor                        = 0.75
    lineBreakMode                             = .byWordWrapping
    translatesAutoresizingMaskIntoConstraints = false
  }

}
