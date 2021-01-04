import UIKit

class TileLayoutBuilder: LayoutBuilder {
  
  // MARK: - Variables
  private static let spacing: CGFloat = 10
  
  static func buildTileLayoutSection(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
    let isPhone = layoutEnvironment.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    let itemCount = isPhone ? 1 : 2
        
    let width = (layoutEnvironment.container.effectiveContentSize.width - spacing) / CGFloat(itemCount)
    let height: CGFloat = (width/500 * 282) + 150
    let size = NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1), heightDimension: NSCollectionLayoutDimension.absolute(height))
          
    let item = NSCollectionLayoutItem(layoutSize: size)
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: itemCount)
    group.interItemSpacing = .fixed(spacing)
    
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = spacing
    section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
    return section
  }
}
