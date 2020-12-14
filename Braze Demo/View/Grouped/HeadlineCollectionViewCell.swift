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

  static func configuredCell() ->  UICollectionView.CellRegistration<HeadlineCollectionViewCell, Subgroup> {
    return UICollectionView.CellRegistration<HeadlineCollectionViewCell, Subgroup> { (cell, indexPath, subgroup) in
      cell.layer.cornerRadius = 15
      cell.layer.masksToBounds = true
      
      let style = NSMutableParagraphStyle()
      style.lineSpacing = 10
      style.alignment = .center
      cell.titleLabel.attributedText = NSAttributedString(string: subgroup.title, attributes: [.paragraphStyle: style])
    }
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
