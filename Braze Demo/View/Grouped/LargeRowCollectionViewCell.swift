import UIKit

class LargeRowCollectionViewCell: UICollectionViewListCell {
  static let cellIdentifier = "LargeRowCollectionViewCell"
  
  // MARK: - Outlets
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!

  func configureCell(_ title: String?, imageUrl: String?) {
    titleLabel.text = title
    imageView.image = UIImage(systemName: "globe")
  }
}
