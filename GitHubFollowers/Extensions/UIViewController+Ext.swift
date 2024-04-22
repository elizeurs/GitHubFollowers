//
//  UIViewController+Ext.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 21/04/24.
//

// import Foundation is already part of UIKit
import UIKit

extension UIViewController {
  
  func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
    // this is a quick way to throw things onto the main thread.
    DispatchQueue.main.async {
      let alertVC = GFAlertVC(alertTitle: title, message: message, buttonTitle: buttonTitle)
      alertVC.modalPresentationStyle = .overFullScreen
      alertVC.modalTransitionStyle = .crossDissolve
      // self - we're in a closure here.
      self.present(alertVC, animated: true)
    }
  }
}
