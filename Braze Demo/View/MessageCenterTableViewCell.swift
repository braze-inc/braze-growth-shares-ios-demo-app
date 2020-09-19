import UIKit

class MessageCenterTableViewCell: UITableViewCell {
  static let cellIdentifier = "MessageCenterTableViewCell"
  
  // MARK: - Outlets
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var titleImageView: UIImageView!
  @IBOutlet weak var titleImageWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var titleImageTrailingConstraint: NSLayoutConstraint!
  @IBOutlet weak var dateLabel: UILabel!
  
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
