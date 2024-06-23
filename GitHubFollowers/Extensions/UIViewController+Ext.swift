//
//  UIViewController+Ext.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 21/04/24.
//

// import Foundation is already part of UIKit
import UIKit
import SafariServices

/*
 extensions must not contain stored properties. so, we are going to make this global.
 fileprivate - anything in this file can you this variable.
*/
//fileprivate var containerView: UIView!

extension UIViewController {
  
  // created to adapt to async/await method
  func presentGFAlert(title: String, message: String, buttonTitle: String) {
      let alertVC = GFAlertVC(alertTitle: title, message: message, buttonTitle: buttonTitle)
      alertVC.modalPresentationStyle  = .overFullScreen
      alertVC.modalTransitionStyle    = .crossDissolve
      present(alertVC, animated: true)
    }
    
    func presentDefaultError() {
      // this is a quick way to throw things onto the main thread.
      DispatchQueue.main.async {
        let alertVC = GFAlertVC(alertTitle: "Something went wrong",
                                message: "We were unable to complete your task at this time. Please try again.",
                                buttonTitle: "Ok")
        alertVC.modalPresentationStyle  = .overFullScreen
        alertVC.modalTransitionStyle    = .crossDissolve
        // self - we're in a closure here.
        self.present(alertVC, animated: true)
      }
  }
  
  func presentSafariVC(with url: URL) {
    let safariVC = SFSafariViewController(url: url)
    safariVC.preferredControlTintColor = .systemGreen
    present(safariVC, animated: true)
  }
}
