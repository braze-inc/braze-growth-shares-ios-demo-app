import UIKit

enum GroupSection: Hashable {
  case blank
  case group(GroupType)
  case ad
  
  enum GroupType {
    case primary
    case secondary
  }
}

extension GroupSection: RawRepresentable {
  typealias RawValue = Int
  
  init?(rawValue: RawValue) {
    switch rawValue {
    case 0:  self = .blank
    case 1:  self = .group(.primary)
    case 2:  self = .group(.secondary)
    case 3:  self = .ad
    default: return nil
    }
  }

  var rawValue: RawValue {
    switch self {
    case .blank:               return 0 
    case .group(.primary):     return 1
    case .group(.secondary):   return 2
    case .ad:                  return 3
    }
  }
}

class GroupListDataSource: NSObject, CollectionViewDataSourceProvider {
  typealias DataSource = UICollectionViewDiffableDataSource<GroupSection, AnyHashable>
  typealias Snapshot = NSDiffableDataSourceSnapshot<GroupSection, AnyHashable>
  
  // MARK: - Variables
  var dataSource: DataSource!
  private weak var delegate: CellActionDelegate?
  
  required init(collectionView: UICollectionView, delegate: CellActionDelegate) {
    super.init()
    self.delegate = delegate
   
    configureLayout(collectionView)
    configureDataSource(collectionView)
    
    collectionView.delegate = self
  }
  
  func applySnapshot(_ content: [ContentCardable], ads: [Ad], animatingDifferences: Bool) {
    guard content is [Group] else { return }
    
    var snapshot = Snapshot()
    
    snapshot.appendSections([.blank, .group(.primary), .group(.secondary), .ad])
    snapshot.appendItems(ads, toSection: .ad)
    snapshot.appendItems(content as! [Group], toSection: .group(.primary))
    
    dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
  }
  
  func reorderDataSource() { return }
  
  func resetDataSource() {
    dataSource.snapshot().itemIdentifiers.forEach { content in
      guard let group = content as? Group, group.isContentCard else { return }
      
      group.logContentCardDismissed()
    }
  }
  
  func configureDataSource(_ collectionView: UICollectionView) {
    dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, content) -> UICollectionViewCell? in
      
      switch content {
      case let ad as Ad:
        let cell: BannerAdCollectionViewCell! = collectionView.dequeueReusablCell(for: indexPath)
        cell.configureCell(ad.imageUrl)
        return cell
      case let group as Group:
        let cell: ItemCollectionViewCell! = collectionView.dequeueReusablCell(for: indexPath)
        cell.configureCell(group.name, nil, nil, "")
        return cell
      default:
        return UICollectionViewCell()
      }
    })
  }
  
  func configureLayout(_ collectionView: UICollectionView) {
    collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
    
      guard let section = GroupSection(rawValue: sectionIndex) else { return nil }
      
      let isPhone = layoutEnvironment.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone
      let spacing: CGFloat = 10
                  
      switch section {
      case .ad:
        let width = collectionView.frame.size.width
        let height: CGFloat = width/394 * 100
        let size = NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1), heightDimension: NSCollectionLayoutDimension.absolute(height))
          
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: spacing, bottom: spacing, trailing: spacing)
        return section
      case .blank:
        let heightDimension = NSCollectionLayoutDimension.estimated(500)
        let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: heightDimension)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
      case .group(.primary), .group(.secondary):
        let itemCount = isPhone ? 1 : 2
            
        let width = (collectionView.frame.size.width - spacing) / CGFloat(itemCount)
        let height: CGFloat = (width/500 * 282) + 450
        let size = NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1), heightDimension: NSCollectionLayoutDimension.absolute(height))
              
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: itemCount)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        return section
      }
    })
  }
}

// MARK: - CollectionViewDelegate
extension GroupListDataSource {  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    guard let content = dataSource.itemIdentifier(for: indexPath) as? ContentCardable, content.isContentCard else { return }
    
    content.logContentCardImpression()
  }
}
