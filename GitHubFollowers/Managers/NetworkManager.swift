//
//  NetworkManager.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 26/04/24.
//

import Foundation

class NetworkManager {
  // singleton
  // static - every network manager will have that variable on it.
  static let shared   = NetworkManager()
  let baseURL         = "https://api.github.com/users/"
  
  // make it private, so it can only be called here.
  private init() {}
  
  // completion handler and closure are the same thing.
  func getFollowers(for username: String, page: Int, completed: @escaping ([Follower]?, ErrorMessage?) -> Void) {
    let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
    
    guard let url = URL(string: endpoint) else {
      completed(nil, .invalidUsername)
      return
    }
    
    // data, response and error are all optional, that's why we have to unwrap all these optionals, that's why we are going to see things like if/let/guard.
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      
      // handle error
      if let _ = error {
        // every time we call "completed", we got to pass in two things, either an array of followers or an error message.
        completed(nil, .unableToComplete)
        // return - if we get the error, we want to return out, like we're done. we don't want to do any more of the function here.
        return
      }
      
      /*
       handle response
       first, checking if response is not nill
       and then, check the statud code on that response.
       200 - means everything went ok.
       */
      guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        // nil for the array of followers.
          completed(nil, .invalidResponse)
        return
      }
      
      guard let data = data  else {
        // nil for the array of followers.
          completed(nil, .invalidData)
        return
      }
      
      // do-try-catch - this is a way to handle the errors
      do {
        /*
         decoder: take the data from the server and decode it into our objects
         encoder: take our object and convert it to a data.
         codable protocol: the combination of encodable and decodable protocols.
         */
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let followers = try decoder.decode([Follower].self, from: data)
        // nil - no error
        completed(followers, nil)
      } catch {
        completed(nil, .invalidData)
//        completed(nil, "The data receivedd from the server was invalid. Please try again.")
      }
    }
    
    // this is what actually starts the network
    task.resume()
  }
}
