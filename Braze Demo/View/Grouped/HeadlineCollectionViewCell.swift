import UIKit

class HeadlineCollectionViewCell: UICollectionViewListCell {
  static let cellIdentifier = "HeadlineCollectionViewCell"
  
  // MARK: - Variables
  @IBOutlet weak var titleLabel: UILabel!

  func configureCell(_ title: String?) {
    guard let title = title else { return }
    
    let style = NSMutableParagraphStyle()
    style.lineSpacing = 10
    style.alignment = .center
    
    titleLabel.attributedText = NSAttributedString(string: title, attributes: [.paragraphStyle: style])
  }
}
