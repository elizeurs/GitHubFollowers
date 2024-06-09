//
//  NetworkManager.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 26/04/24.
//

import UIKit

class NetworkManager {
  // singleton
  // static - every network manager will have that variable on it.
  static let shared           = NetworkManager()
  // make it private, that the only one we can access here is cache.
  private let baseURL         = "https://api.github.com/users/"
  // creating the image cache.
  let cache                   = NSCache<NSString, UIImage>()
  
  // make it private, so it can only be called here.
  private init() {}
  
  // completion handler and closure are the same thing.
  
  // the old way
//  func getFollowers(for username: String, page: Int, completed: @escaping ([Follower]?, ErrorMessage?) -> Void) {
  
  // the new way, using enum Result
  // < > - indicates that it takes in a generic.
  // can use the default Error or our custom GFError.
  
  /*
   @escaping:
   closures are either escaping or non-escaping
   */
    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], GFError>) -> Void) {
    let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
    
    guard let url = URL(string: endpoint) else {
//      the old way
//      completed(nil, .invalidUsername)
//      the new way, with Result
      completed(.failure(.invalidUsername))
      return
    }
    
    // data, response and error are all optional, that's why we have to unwrap all these optionals, that's why we are going to see things like if/let/guard.
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      
      // handle error
      if let _ = error {
        // every time we call "completed", we got to pass in two things, either an array of followers or an error message.
//        old way
//        completed(nil, .unableToComplete)
        completed(.failure(.unableToComplete))
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
        completed(.failure(.unableToComplete))
        return
      }
      
      guard let data = data  else {
        // nil for the array of followers.
//          completed(nil, .invalidData)
        completed(.failure(.invalidData))
        return
      }
      
      // do-try-catch - this is a way to handle the errors
      do {
        /*
         decoder: take the data from the server and decode it into our objects
         encoder: take our object and convert it to a data.
         codable protocol: the combination of encodable and decodable protocols.
         */
        let decoder                     = JSONDecoder()
        decoder.keyDecodingStrategy     = .convertFromSnakeCase
        decoder.dateDecodingStrategy    = .iso8601
        let followers                   = try decoder.decode([Follower].self, from: data)
        // nil - no error
        completed(.success(followers))
      } catch {
        completed(.failure(.invalidData))
//        completed(nil, "The data receivedd from the server was invalid. Please try again.")
      }
    }
    
    // this is what actually starts the network
    task.resume()
  }
  
  
  func getUserInfo(for username: String, completed: @escaping (Result<User, GFError>) -> Void) {
  let endpoint = baseURL + "\(username)"
  
  guard let url = URL(string: endpoint) else {
    completed(.failure(.invalidUsername))
    return
  }
  
  let task = URLSession.shared.dataTask(with: url) { data, response, error in
    
    // handle error
    if let _ = error {
      completed(.failure(.unableToComplete))
      return
    }
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
      // nil for the array of followers.
      completed(.failure(.unableToComplete))
      return
    }
    
    guard let data = data  else {
      completed(.failure(.invalidData))
      return
    }
    
    // do-try-catch - this is a way to handle the errors
    do {
      /*
       decoder: take the data from the server and decode it into our objects
       encoder: take our object and convert it to a data.
       codable protocol: the combination of encodable and decodable protocols.
       */
      let decoder                     = JSONDecoder()
      decoder.keyDecodingStrategy     = .convertFromSnakeCase
      decoder.dateDecodingStrategy    = .iso8601
      let user = try decoder.decode(User.self, from: data)
      // nil - no error
      completed(.success(user))
    } catch {
      completed(.failure(.invalidData))
//        completed(nil, "The data receivedd from the server was invalid. Please try again.")
    }
  }
  
  // this is what actually starts the network
  task.resume()
}
  
  func downloadImage(from urlString: String, completed: @escaping (UIImage?)-> Void ) {
    
    let cacheKey = NSString(string: urlString)
    
    if let image = cache.object(forKey: cacheKey) {
      completed(image)
      return
    }
    
    guard let url = URL(string: urlString) else {
      return
    }
    
    let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
      
      guard let self = self,
      error == nil,
        let response = response as? HTTPURLResponse, response.statusCode == 200,
        let data = data,
            let image = UIImage(data: data) else {
              completed(nil)
              return
            }
        
        self.cache.setObject(image, forKey: cacheKey)
        completed(image)
    }
    
    task.resume()
  }
}
