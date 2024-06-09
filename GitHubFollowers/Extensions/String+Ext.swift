//
//  String+Ext.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 23/05/24.
//

import Foundation

extension String {
  
  // using decoder.dateDecodingStrategy    = .iso8601
  func convertToDate() -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.timeZone = .current
    
    return dateFormatter.date(from: self)
  }
  
  func convertToDisplayFormat() -> String {
    guard let date = self.convertToDate() else { return "N/A" }
    return date.convertToMonthYearFormat()
  }
}
