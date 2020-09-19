import UIKit

class BannerAdCollectionViewCell: UICollectionViewCell {
  static let cellIdentifier = "BannerAdCollectionViewCell"
  
  // MARK: - Variables
  @IBOutlet private weak var bannerImageView: UIImageView!
}

// MARK: - View lifecycle
extension BannerAdCollectionViewCell {
  override func prepareForReuse() {
    bannerImageView.image = nil
  }
}
  
// MARK: - Public
extension BannerAdCollectionViewCell {
  func configureCell(_ imageUrl: String?) {
    if let urlString = imageUrl, let url = URL(string: urlString) {
        ImageCache.sharedCache.image(from: url) { image in
            self.bannerImageView.image = image
      }
    }
  }
}
