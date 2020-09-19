import UIKit

class ContentCardFullPageView: UIView {
  
  // MARK: - Variables
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var imageView: UIImageView?
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var messageLabel: UILabel!
  
  func configureView(_ title: String?, _ message: String?, _ imageUrl: String?) {
    titleLabel.text = title
    messageLabel.text = message
    
    if let urlString = imageUrl, let url = URL(string: urlString) {
      ImageCache.sharedCache.image(from: url) { image in
        if let image = image {
          self.imageView?.image = image
        } else {
          self.hideImage()
        }
      }
    } else {
      hideImage()
    }
  }
}

private extension ContentCardFullPageView {
  func hideImage() {
    imageView?.removeFromSuperview()
    NSLayoutConstraint.activate([NSLayoutConstraint(item: titleLabel!, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 20)])
  }
}
