import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
  static let cellIdentifier = "ItemCollectionViewCell"
    
  // MARK: - Outlets
  @IBOutlet private weak var borderView: UIView!
  @IBOutlet private weak var coverImageView: UIImageView!
  @IBOutlet private weak var titlelLabel: UILabel!
  @IBOutlet private weak var priceLabel: UILabel!
}

// MARK: - View lifecycle
extension ItemCollectionViewCell {
  override func awakeFromNib() {
    super.awakeFromNib()
    borderView.layer.borderWidth = 1
    borderView.layer.borderColor = UIColor.label.cgColor
  }
  
  override func prepareForReuse() {
    coverImageView.image = nil
  }
}

// MARK: - Public
extension ItemCollectionViewCell {
  func configureCell(_ title: String?, _ price: Decimal?, _ imageUrl: String?) {
    titlelLabel.text = title
    priceLabel.text = price?.formattedCurrencyString()
      
    if let urlString = imageUrl, let url = URL(string: urlString) {
        ImageCache.sharedCache.image(from: url) { image in
            self.coverImageView.image = image
      }
    }
  }
}
