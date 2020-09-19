import UIKit

class ShoppingCartTableViewCell: UITableViewCell {
  static let cellIdentifier = "ShoppingCartTableViewCell"
  
  // MARK: - Outlets
  @IBOutlet private weak var coverImageView: UIImageView!
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var priceLabel: UILabel!
}

// MARK: - View lifecycle
extension ShoppingCartTableViewCell {
  override func prepareForReuse() {
    coverImageView.image = nil
  }
}

// MARK: - Public
extension ShoppingCartTableViewCell {
  func configure(_ title: String?, _ price: Decimal?, _ imageUrl: String?) {
    titleLabel.text = title
    priceLabel.text = price?.formattedCurrencyString()
    
    if let urlString = imageUrl, let url = URL(string: urlString) {
      ImageCache.sharedCache.image(from: url) { image in
        self.coverImageView.image = image
      }
    }
  }
}
