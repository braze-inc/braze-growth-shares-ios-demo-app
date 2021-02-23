import UIKit

class MessageCenterTableViewCell: UITableViewCell {
  static let cellIdentifier = "MessageCenterTableViewCell"
  
  // MARK: - Outlets
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var titleImageView: UIImageView!
  @IBOutlet private weak var titleImageWidthConstraint: NSLayoutConstraint!
  @IBOutlet private weak var titleImageTrailingConstraint: NSLayoutConstraint!
  @IBOutlet private weak var dateLabel: UILabel!
  
  func configureCell(_ title: String?, _ imageUrl: String?, _ unixDate: Double?) {
    titleLabel.text = title
    
    if let urlString = imageUrl, let url = URL(string: urlString) {
      ImageCache.sharedCache.image(from: url) { image in
        if let image = image {
          self.titleImageView.image = image
        } else {
          self.hideImage()
        }
      }
    } else {
      hideImage()
    }
    
    guard let unixDate = unixDate else { return }
    dateLabel.text = unixDate.formattedDateString()
  }
}

// MARK: - Private Methods
private extension MessageCenterTableViewCell {
  func hideImage() {
    titleImageWidthConstraint.constant = 0
    titleImageTrailingConstraint.constant = 0
  }
}
