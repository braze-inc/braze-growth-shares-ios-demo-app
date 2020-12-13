import UIKit

class SmallRowCollectionViewCell: UICollectionViewListCell {
  static func configuredListCell() -> UICollectionView.CellRegistration<UICollectionViewListCell, Subgroup> {
    return UICollectionView.CellRegistration<UICollectionViewListCell, Subgroup> { (cell, indexPath, subgroup) in
      var content = UIListContentConfiguration.valueCell()
      content.image = UIImage(systemName: "globe")
      content.attributedText = subgroup.title.firstWordBold()
      cell.contentConfiguration = content
      cell.accessories = [.disclosureIndicator()]
    }
  }
}
