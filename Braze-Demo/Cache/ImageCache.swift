/*
I would advise against using this code in a fully functioning production application. ImageCache is not built to scale well (UIImage are ~ raw bitmap data, e.g: 1000px x 1000px x 4 color components ~= 7MB)
 */

import UIKit

class ImageCache: NSObject {
  static let sharedCache = ImageCache()
  private let cache = NSCache<NSURL, UIImage>()
    
  func image(from url: URL?, completion: @escaping (UIImage?) -> ()) {
    guard let url = url else { return completion(nil) }
        
    if let cachedImage = cache.object(forKey: url as NSURL) {
      return completion(cachedImage)
    }
      
    URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
      guard let data = data else { return completion(nil) }
            
      DispatchQueue.main.async {
        guard let self = self, let downloadedImage = UIImage(data: data) else { return completion(nil) }
                
        self.cache.setObject(downloadedImage, forKey: url as NSURL)
        completion(downloadedImage)
      }
    }.resume()
  }
}
