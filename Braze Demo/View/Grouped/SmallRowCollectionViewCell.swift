import UIKit

class SmallRowCollectionViewCell: UICollectionViewListCell {
  static let cellIdentifier = "SmallRowCollectionViewCell"
  
  // MARK: - Outlets
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!

  func configureCell(_ title: String?, imageUrl: String?) {
    titleLabel.text = title
    imageView.image = UIImage(systemName: "globe")
  
    self.accessories = [.disclosureIndicator()]
  }
}
