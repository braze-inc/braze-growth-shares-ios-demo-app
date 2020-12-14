import UIKit

class GroupedLayoutBuilder: LayoutBuilder {
  
  // MARK: - Variables
  static let sectionBackgroundDecorationElementKind = "section-background-element-kind"
  private static let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: GroupedLayoutBuilder.sectionBackgroundDecorationElementKind)
  private static let horizontalSpacing: CGFloat = 20
  private static let verticalSpacing: CGFloat = 10
  
  static func buildBlankLayoutSection() -> NSCollectionLayoutSection {
    let heightDimension = NSCollectionLayoutDimension.estimated(300)
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),heightDimension: heightDimension)
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: heightDimension)
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    return section
  }
  
  static func buildSmallRowLayoutSection(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
    var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
    configuration.backgroundColor = .systemGroupedBackground
    let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
    section.contentInsets = NSDirectionalEdgeInsets(top: verticalSpacing, leading: horizontalSpacing, bottom: verticalSpacing, trailing: horizontalSpacing)
    return section
  }
  
  static func buildLargeRowLayoutSection() -> NSCollectionLayoutSection {
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
    let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(20))
    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind:  UICollectionView.elementKindSectionFooter, alignment: .bottom)
    let size = NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1), heightDimension: NSCollectionLayoutDimension.absolute(80))
    let item = NSCollectionLayoutItem(layoutSize: size)
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
    let section = NSCollectionLayoutSection(group: group)
    section.decorationItems = [sectionBackgroundDecoration]
    section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
    section.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: horizontalSpacing, bottom: 0.0, trailing: horizontalSpacing)
    return section
  }
  
  static func buildHeadlineLayoutSection(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let groupFractionalWidth = CGFloat(layoutEnvironment.container.effectiveContentSize.width > 500 ?
        0.425 : 0.85)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth), heightDimension: .absolute(100))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging
    section.interGroupSpacing = horizontalSpacing
    section.contentInsets = NSDirectionalEdgeInsets(top: verticalSpacing, leading: horizontalSpacing, bottom: verticalSpacing, trailing: horizontalSpacing)
    section.decorationItems = [sectionBackgroundDecoration]
    return section
  }
}
