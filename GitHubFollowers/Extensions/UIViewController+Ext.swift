//
//  UIViewController+Ext.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 21/04/24.
//

// import Foundation is already part of UIKit
import UIKit

/*
 extensions must not contain stored properties. so, we are going to make this global.
 fileprivate - anything in this file can you this variable.
*/
fileprivate var containerView: UIView!

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
  
  func showLoadingView() {
    containerView = UIView(frame: view.bounds)
    view.addSubview(containerView)
    
    containerView.backgroundColor   = .systemBackground
    containerView.alpha             = 0
    
    UIView.animate(withDuration: 0.25) { containerView.alpha = 0.8 }
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    containerView.addSubview(activityIndicator)
    
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
    
    activityIndicator.startAnimating()
  }
  
  func dismissLoadingView() {
    DispatchQueue.main.async {
      containerView.removeFromSuperview()
      containerView = nil
    }
  }
}
