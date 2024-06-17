//
//  UserInfoVC.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 14/05/24.
//

import UIKit

protocol UserInfoVCDelegate: AnyObject {
  func didRequestFollowers(for username: String)
}

class UserInfoVC: GFDataLoadingVC {
  
  let scrollView          = UIScrollView()
  let contentView         = UIView()
  
  let headerView          = UIView()
  let itemViewOne         = UIView()
  let itemViewTwo         = UIView()
  let dateLabel           = GFBodyLabel(textAlignment: .center)
  var itemViews: [UIView] = []
  
  var username: String!
  weak var delegate: UserInfoVCDelegate!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    configureScrollView()
    layoutUI()
    getUserInfo()
    
    //    print(username!)
    
  }
  
  func configureViewController() {
    view.backgroundColor = .systemBackground
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
    navigationItem.rightBarButtonItem = doneButton
  }
  
  func configureScrollView() {
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
//    scrollView.translatesAutoresizingMaskIntoConstraints = false
//    contentView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.pinToEdges(of: view)
    contentView.pinToEdges(of: scrollView)
    
    NSLayoutConstraint.activate([
      contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
      contentView.heightAnchor.constraint(equalToConstant: 600)
    ])
  }
  
  func getUserInfo() {
    NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
      guard let self = self else { return }
      
      switch result {
      case .success(let user):
        DispatchQueue.main.async { self.configureUIElements(with: user)
          //        print(user)
          self.configureUIElements(with: user)
        }
        
      case .failure(let error):
        self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
      }
    }
  }
  
  func configureUIElements(with user: User) {
    self.add(childVC: GFRepoItemVC(user: user, delegate: self), to: self.itemViewOne)
    self.add(childVC: GFFollowerItemVC(user: user, delegate: self), to: self.itemViewTwo)
    self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
    //          self.dateLabel.text = "Oct 13"
    //          self.dateLabel.text = user.createdAt
    // self.dateLabel.text = "GitHub since \(user.createdAt.convertToDisplayFormat())"
    self.dateLabel.text = "GitHub since \(user.createdAt.convertToMonthYearFormat())"
    
  }
  
  func layoutUI() {
    let padding: CGFloat    = 20
    let itemHeight: CGFloat = 140
    
    itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
    
    for itemView in itemViews {
      contentView.addSubview(itemView)
      itemView.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
        itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
        itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
      ])
    }
    
    //    itemViewOne.backgroundColor = .systemPink
    //    itemViewTwo.backgroundColor = .systemBlue
    
    NSLayoutConstraint.activate([
      headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
      headerView.heightAnchor.constraint(equalToConstant: 210),
      
      itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
      itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
      
      itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
      itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
      
      dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
      dateLabel.heightAnchor.constraint(equalToConstant: 50)
    ])
  }
  
  func add(childVC: UIViewController, to containerView: UIView) {
    addChild(childVC)
    containerView.addSubview(childVC.view)
    childVC.view.frame = containerView.bounds
    childVC.didMove(toParent: self)
  }
  
  @objc func dismissVC() {
    dismiss(animated: true)
  }
}

extension UserInfoVC: GFRepoItemVCDelegate {
  
  func didTapGitHubProfile(for user: User) {
    // Show safari view controller
    //    print("My button was tapped!!!")
    guard let url = URL(string: user.htmlUrl) else {
      presentGFAlertOnMainThread(title: "Invalid URL", message: "The url attached to this user is invalid.", buttonTitle: "Ok")
      return
    }
    
    presentSafariVC(with: url)
  }
}

extension UserInfoVC: GFFollowerItemVCDelegate {
  
  func didTapGetFollowers(for user: User) {
    // dismissvc
    // tell follower list screen the new user
    guard user.followers != 0 else {
      presentGFAlertOnMainThread(title: "No followers", message: "This user has no followers. What a shame 😞.", buttonTitle: "So sad")
      return
    }
    
    delegate.didRequestFollowers(for: user.login)
    dismissVC()
  }
}
