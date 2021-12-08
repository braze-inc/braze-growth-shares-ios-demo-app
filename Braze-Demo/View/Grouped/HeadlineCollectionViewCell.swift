import UIKit

class HeadlineCollectionViewCell: UICollectionViewListCell {
  static let cellIdentifier = "HeadlineCollectionViewCell"
  
  // MARK: - Variables
  let titleLabel = UILabel()
  
  override init(frame: CGRect) {
      super.init(frame: frame)
      configure()
  }
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}

// MARK: - Private
private extension HeadlineCollectionViewCell {
  func configure() {
    titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
    titleLabel.numberOfLines = 2
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(titleLabel)
    
    let inset: CGFloat = 10
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
      titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
    ])
  }
}
