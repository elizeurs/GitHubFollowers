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
  
  init(textAlignment: NSTextAlignment) {
    super.init(frame: .zero)
    self.textAlignment = textAlignment
    configure()
  }
  
  private func configure() {
    textColor                   = .secondaryLabel
    font                        = UIFont.preferredFont(forTextStyle: .body)
    adjustsFontSizeToFitWidth   = true
    // 0.75 - 75%
    minimumScaleFactor          = 0.75
    lineBreakMode               = .byWordWrapping
    translatesAutoresizingMaskIntoConstraints = false
  }

}
