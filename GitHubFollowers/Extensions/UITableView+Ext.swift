//
//  UITableView+Ext.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 14/06/24.
//

import UIKit

extension UITableView {
  
  // we can't use this func on this project, 'cause we are doing other stuff on the main thread, Dispatch.
  func reloadDataOnMainThread() {
    DispatchQueue.main.async { self.reloadData() }
  }
  
  // remove empty cells on a tableView.
  func removeExcessCells() {
    tableFooterView = UIView(frame: .zero)
  }
}
