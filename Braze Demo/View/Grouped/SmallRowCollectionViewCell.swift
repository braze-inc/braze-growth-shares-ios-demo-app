import UIKit

class SmallRowCollectionViewCell: UICollectionViewListCell {
  static let cellIdentifier = "SmallRowCollectionViewCell"
  
  // MARK: - Outlets
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.accessories = [.disclosureIndicator()]
  }

  func configureCell(_ title: String?, imageUrl: String?) {
    if let title = title {
      titleLabel.attributedText = title.firstWordBold()
    }
    
    imageView.image = UIImage(systemName: "globe")
  }
}
