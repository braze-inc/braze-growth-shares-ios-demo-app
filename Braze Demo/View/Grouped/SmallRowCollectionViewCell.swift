import UIKit

class SmallRowCollectionViewCell: UICollectionViewListCell {
  static func configuredCell() -> UICollectionView.CellRegistration<SmallRowCollectionViewCell, Group> {
    return UICollectionView.CellRegistration<SmallRowCollectionViewCell, Group> { (cell, indexPath, subgroup) in
      var content = UIListContentConfiguration.valueCell()
      content.image = UIImage(systemName: "globe")
      content.attributedText = subgroup.title.firstWordBold()
      cell.contentConfiguration = content
      cell.accessories = [.disclosureIndicator()]
    }
  }
}
