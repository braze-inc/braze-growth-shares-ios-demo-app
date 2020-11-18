import UIKit

enum GroupSection: Hashable {
  case blank
  case group(GroupType)
  case ad
  
  enum GroupType {
    case primary
    case secondary
    case headline
    case info
  }
}

extension GroupSection: RawRepresentable {
  typealias RawValue = Int
  
  init?(rawValue: RawValue) {
    switch rawValue {
    case 0: self = .blank
    case 1: self = .group(.primary)
    case 2: self = .group(.secondary)
    case 3: self = .group(.headline)
    case 4: self = .group(.info)
    case 5: self = .ad
    default: return nil
    }
  }

  var rawValue: RawValue {
    switch self {
    case .blank:             return 0
    case .group(.primary):   return 1
    case .group(.secondary): return 2
    case .group(.headline):  return 3
    case .group(.info):      return 4
    case .ad:                return 5
    }
  }
}

class GroupListDataSource: NSObject, CollectionViewDataSourceProvider {
  typealias DataSource = UICollectionViewDiffableDataSource<GroupSection, AnyHashable>
  typealias Snapshot = NSDiffableDataSourceSnapshot<GroupSection, AnyHashable>
  
  // MARK: - Variables
  private var dataSource: DataSource!
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
    
    snapshot.appendSections([.blank, .group(.primary), .group(.secondary), .group(.headline), .group(.info), .ad])
    snapshot.appendItems(["Blank"], toSection: .blank)
    snapshot.appendItems(ads, toSection: .ad)
    
    let groups = content as! [Group]
    var primaryItems = [Subgroup]()
    groups.forEach {
      switch $0.style {
      case .smallRow:
      if primaryItems.isEmpty {
        primaryItems += $0.items
        snapshot.appendItems(primaryItems, toSection: .group(.primary))
      } else {
        snapshot.appendItems($0.items, toSection: .group(.secondary))
      }
      case .headline:
        snapshot.appendItems($0.items, toSection: .group(.headline))
      case .largeRow:
        snapshot.appendItems($0.items, toSection: .group(.info))
      default: break
      }
    }
    
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
    dataSource = UICollectionViewDiffableDataSource<GroupSection, AnyHashable>(collectionView: collectionView) { (collectionView, indexPath, content) -> UICollectionViewCell? in
      
      switch content {
      case is String:
        let cell: BlankCollectionViewCell! = collectionView.dequeueReusablCell(for: indexPath)
        return cell
      case let ad as Ad:
        let cell: BannerAdCollectionViewCell! = collectionView.dequeueReusablCell(for: indexPath)
        cell.configureCell(ad.imageUrl)
        return cell
      case let subgroup as Subgroup:
        switch GroupSection(rawValue: indexPath.section) {
        case .group(.primary), .group(.secondary):
          let cell: SmallRowCollectionViewCell! = collectionView.dequeueReusablCell(for: indexPath)
          cell.configureCell(subgroup.title, imageUrl: nil)
          return cell
        case .group(.headline):
          let cell: HeadlineCollectionViewCell! = collectionView.dequeueReusablCell(for: indexPath)
          cell.configureCell(subgroup.title)
          return cell
        case .group(.info):
          let cell: LargeRowCollectionViewCell! = collectionView.dequeueReusablCell(for: indexPath)
          cell.configureCell(subgroup.title, imageUrl: nil)
          return cell
        default: return UICollectionViewCell()
        }
      default: return UICollectionViewCell()
      }
    }
  }
  
  func configureLayout(_ collectionView: UICollectionView) {
    collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
    
      guard let section = GroupSection(rawValue: sectionIndex) else { return nil }
      
      let horizontalSpacing: CGFloat = 20
      let verticalSpacing: CGFloat = 10
                  
      switch section {
      case .ad:
        let width = collectionView.frame.size.width
        let height: CGFloat = width/394 * 100
        let size = NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1), heightDimension: NSCollectionLayoutDimension.absolute(height))
          
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: verticalSpacing, trailing: 0)
        return section
      case .blank:
        let heightDimension = NSCollectionLayoutDimension.estimated(300)
        let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: heightDimension)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
      case .group(.primary), .group(.secondary):
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.backgroundColor = .systemGroupedBackground
        let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
        section.contentInsets = NSDirectionalEdgeInsets(top: verticalSpacing, leading: horizontalSpacing, bottom: verticalSpacing, trailing: horizontalSpacing)
        return section
      case .group(.info), .group(.headline):
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.backgroundColor = .systemGroupedBackground
        configuration.showsSeparators = false
        let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
        section.contentInsets = NSDirectionalEdgeInsets(top: verticalSpacing, leading: horizontalSpacing, bottom: verticalSpacing, trailing: horizontalSpacing)
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
