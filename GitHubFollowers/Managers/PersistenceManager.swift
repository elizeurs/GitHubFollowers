//
//  PersistenceManager.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 01/06/24.
//

import Foundation

enum PersitenceActionType {
  case add, remove
}

/*
 enum: you could't initialize an empty enum
 vs
 struct: you can initialize an empty struct
 */
enum PersistenceManager {
  
  static private let defaults = UserDefaults.standard
  
  enum Keys {
    static let favorites = "favorites"
  }
  
  static func updateWith(favorite: Follower, actionType: PersitenceActionType, completed: @escaping (GFError?) -> Void) {
    retrieveFavorites { result in
      switch result {
      case .success(let favorites):
        var retrievedFavorites = favorites
        
        switch actionType {
        case .add:
          guard !retrievedFavorites.contains(favorite) else {
            completed(.alreadyInFavorites)
            return
          }
          
          retrievedFavorites.append(favorite)
          
        case .remove:
          // $0 - it's each item as it's iterating through.
          retrievedFavorites.removeAll { $0.login == favorite.login }
        }
        
        completed(save(favorites: retrievedFavorites))
        
      case .failure(let error):
        completed(error)
      }
    }
  }
  
  static func retrieveFavorites(completed: @escaping (Result<[Follower], GFError>) -> Void) {
    guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
      completed(.success([]))
      return
    }
    
    do {
      let decoder = JSONDecoder()
      let favorites = try decoder.decode([Follower].self, from: favoritesData)
      completed(.success(favorites))
    } catch {
      completed(.failure(.unableToFavorite))
    }
  }
  
  // when we're saving it, we're encoding it, and when we're retrieving it, we're decoding it from data.
  static func save(favorites: [Follower]) -> GFError? {
    do {
      let encoder = JSONEncoder()
      let encodedFavorites = try encoder.encode(favorites)
      defaults.set(encodedFavorites, forKey: Keys.favorites)
      return nil
    } catch {
      return .unableToFavorite
    }
  }
}
