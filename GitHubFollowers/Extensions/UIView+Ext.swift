//
//  UIView+Ext.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 12/06/24.
//

import UIKit

extension UIView {
  
  // Variadic Parameter - i can pass any number of views into addSubviews. turns views into a array.
  func addSubviews(_ views: UIView...) {
      for view in views { addSubview(view) }
    }
  }
