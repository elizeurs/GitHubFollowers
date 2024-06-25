//
//  SearchVC.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 16/04/24.
//

import UIKit

class SearchVC: UIViewController {
  
  let logoImageView = UIImageView()
  let usernameTextField = GFTextField()
  let callToActionButton = GFButton(color: .systemGreen, title: "Get Followers", systemImageName: "person.3")
  
  var isUsernameEntered: Bool { return !usernameTextField.text!.isEmpty }
  
  // only gets called the first time the view loads.
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    view.addSubviews(logoImageView, usernameTextField, callToActionButton)
    configureLogoImageView()
    configureTextField()
    configureCallToActionButton()
    createDismissKeyboardTapGesture()
  }
  
  // it happens every time the view will appear.
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    usernameTextField.text = "" 
    // solve NavBar issue, when you try to swipe back(left to right) from FollowerListVC to SearchVC.
    navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  func createDismissKeyboardTapGesture() {
    // dismiss keyboard
    let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
    view.addGestureRecognizer(tap)
  }
  
  @objc func pushFollowerListVC() {
    guard isUsernameEntered else {
      presentGFAlert(title: "Empty Username", message: "Please enter a username. We need to know who to look for 😀.", buttonTitle: "Ok")
      print("No username")
      return
    }
    
    usernameTextField.resignFirstResponder()
    
    let followerListVC = FollowerListVC(username: usernameTextField.text!)
    navigationController?.pushViewController(followerListVC, animated: true)
  }
  
  func configureLogoImageView() {
    logoImageView.translatesAutoresizingMaskIntoConstraints = false
//    logoImageView.image = UIImage(named: "gh-logo")
    logoImageView.image = Images.ghLogo
    
    // || - or
    let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80
    
    NSLayoutConstraint.activate([
      logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
      logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      logoImageView.heightAnchor.constraint(equalToConstant: 200),
      logoImageView.widthAnchor.constraint(equalToConstant: 200)
      
    ])
  }
  
  func configureTextField() {
    // self - SearchVC
    usernameTextField.delegate = self
    
    NSLayoutConstraint.activate([
      usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 50),
      usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
      usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
      usernameTextField.heightAnchor.constraint(equalToConstant: 50),
    ])
  }
  
  func configureCallToActionButton() {
    callToActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
    
    NSLayoutConstraint.activate([
      callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
      callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
      callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
      callToActionButton.heightAnchor.constraint(equalToConstant: 50),
    ])
  }
}

extension SearchVC: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    print("Did Tap Return")
    pushFollowerListVC()
    return true
  }
}
