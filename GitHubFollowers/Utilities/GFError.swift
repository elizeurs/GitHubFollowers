//
//  GFError.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 16/05/24.
//

import Foundation

/*
 associated value   : each case can have one type.
 raw value          : all the cases conform to one type. like in this case.
 */
//enum ErrorMessage: String {
// conforming to Error protocol, so i can use Result type (Result<Success, Failure: Error>)
enum GFError: String, Error {
  case invalidUsername    = "This username createdd an invalidd request. Please try again."
  case unableToComplete   = "Unable to complete your request. Please check your internet connection"
  case invalidResponse    = "Invalid response from the server. Please try again."
  case invalidData        = "The data receivedd from the server was invalid. Please try again."
}

