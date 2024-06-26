//
//  Date+Ext.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 23/05/24.
//

import Foundation

extension Date {
  
  // new way
  func convertToMonthYearFormat() -> String {
    return formatted(.dateTime.month().year())
    // options available.
    // option + click .month, you can see optitons available and/or click on " Open in Developer Documentation" after that.
    //    return formatted(.dateTime.month(.wide).year(.twoDigits))
    // default
//    return formatted()
  }
  
  // old way
//  func convertToMonthYearFormat() -> String {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "MMM yyyy"
//    return dateFormatter.string(from: self)
//  }
}
