import UIKit

class LargeRowCollectionViewCell: UICollectionViewListCell {
  static let cellIdentifier = "LargeRowCollectionViewCell"
  
  // MARK: - Outlets
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!

  func configureCell(_ title: String?, imageUrl: String?) {
    titleLabel.text = title
    
    if let urlString = imageUrl, let url = URL(string: urlString) {
        ImageCache.sharedCache.image(from: url) { image in
          self.imageView.image = image
      }
    } else {
      imageView.image = UIImage(systemName: "globe")
    }
  }
}
