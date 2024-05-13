//
//  GFAvatarImageView.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 30/04/24.
//

import UIKit

class GFAvatarImageView: UIImageView {

  let cache             = NetworkManager.shared.cache
  let placeholderImage  = UIImage(named: "avatar-placeholder")

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configure() {
    layer.cornerRadius  = 10
    clipsToBounds       = true
    image               = placeholderImage
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  func downloadImage(from urlString: String) {
    
    // urlString - cannot convert value of type 'String' to expected argument type 'NSString',
    // so we need to convert this to the NSString.
    let cacheKey = NSString(string: urlString)
    
    // once we have our image, we need to return out of here, 'cause we don't want to run any of the network calls, if we have the cached image.
    if let image = cache.object(forKey: cacheKey) {
      self.image = image
      return
    }
    
    // if we don't have the cached image, we are going to proceed through the rest of the function,and it's going to dl the image.
    guard let url = URL(string: urlString) else { return }
    
    let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
      guard let self = self else { return }
      // not handling the errors
      if error != nil { return }
      guard let response = response as? HTTPURLResponse, response.statusCode == 200  else { return }
      // making sure we actually have data
      guard let data = data else { return }
      
      // now, let's actually handle our data now that we have it.
      // if anything goes wrong with this network call, we're just getting out of here, not doing anything else and just showing our placeholder.
      guard let image = UIImage(data: data) else { return }
      
      // setting the image into the cache.
      self.cache.setObject(image, forKey: cacheKey)
      
      // anytime you update your ui, you have to do it on the main thread.
      DispatchQueue.main.async {
        self.image = image
      }
      
    }
    // that's what kick off the network call
    task.resume()
  }
}
