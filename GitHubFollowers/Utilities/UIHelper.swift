//
//  UIHelper.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 07/05/24.
//

// UIKit brings Foundation. if you're importing both of them, that's redundant.
import UIKit

struct UIHelper {
  
  // static - so i can access it.
  static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
    let width                         = view.bounds.width
    let padding: CGFloat              = 12
    let minimunItemSpacing: CGFloat   = 10
    let availableWidth                = width - (padding * 2) - (minimunItemSpacing * 2)
    let itemWidth                     = availableWidth / 3
    
    let flowLayout                    = UICollectionViewFlowLayout()
    flowLayout.sectionInset           = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    flowLayout.itemSize               = CGSize(width: itemWidth, height: itemWidth + 40)
    
    return flowLayout
  }
  
}
