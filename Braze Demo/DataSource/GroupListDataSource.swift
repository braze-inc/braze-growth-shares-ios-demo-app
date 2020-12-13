import UIKit

class GroupListDataSource: NSObject, CollectionViewDataSourceProvider {
  typealias DataSource = UICollectionViewDiffableDataSource<GroupSection, AnyHashable>
  typealias Snapshot = NSDiffableDataSourceSnapshot<GroupSection, AnyHashable>
  
  // MARK: - Variables
  private static let sectionBackgroundDecorationElementKind = "section-background-element-kind"
  private var dataSource: DataSource!
  private weak var delegate: CellActionDelegate?
  
  required init(collectionView: UICollectionView, delegate: CellActionDelegate) {
    super.init()
    self.delegate = delegate
   
    configureDataSource(collectionView)
    
    collectionView.collectionViewLayout = configureLayout()
    collectionView.collectionViewLayout.register(SectionBackgroundDecorationView.self,forDecorationViewOfKind: GroupListDataSource.sectionBackgroundDecorationElementKind)
    
    collectionView.delegate = self
  }
  
  func applySnapshot(_ content: [ContentCardable], ads: [Ad], animatingDifferences: Bool) {
    guard content is [Group] else { return }
    
    var snapshot = Snapshot()
    
    snapshot.appendSections(GroupSection.allCases)
    snapshot.appendItems(["Blank"], toSection: .blank)
    snapshot.appendItems(ads, toSection: .ad)
    
    let groups = content as! [Group]
    var primaryItems = [Subgroup]()
    groups.forEach {
      switch $0.style {
      case .smallRow:
      if primaryItems.isEmpty {
        primaryItems += $0.items
        snapshot.appendItems(primaryItems, toSection: .primary)
      } else {
        snapshot.appendItems($0.items, toSection: .secondary)
      }
      case .headline:
        snapshot.appendItems($0.items, toSection: .headline)
      case .largeRow:
        snapshot.appendItems($0.items, toSection: .large)
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
        case .primary, .secondary:
          return collectionView.dequeueConfiguredReusableCell(using: SmallRowCollectionViewCell.configuredCell(), for: indexPath, item: subgroup)
        case .headline:
          return collectionView.dequeueConfiguredReusableCell(using: HeadlineCollectionViewCell.configuredCell(), for: indexPath, item: subgroup)
        case .large:
          let cell: LargeRowCollectionViewCell! = collectionView.dequeueReusablCell(for: indexPath)
          cell.configureCell(subgroup.title, imageUrl: nil)
          return cell
        default: return UICollectionViewCell()
        }
      default: return UICollectionViewCell()
      }
    }
  }
  
  func configureLayout() -> UICollectionViewLayout {
    let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
    
      guard let section = GroupSection(rawValue: sectionIndex) else { return nil }
      
      let horizontalSpacing: CGFloat = 20
      let verticalSpacing: CGFloat = 10
                  
      switch section {
      case .ad:
        let width = layoutEnvironment.container.effectiveContentSize.width
        let height: CGFloat = width/394 * 100
        let size = NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1), heightDimension: NSCollectionLayoutDimension.absolute(height))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        return section
      case .blank:
        let heightDimension = NSCollectionLayoutDimension.estimated(300)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),heightDimension: heightDimension)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
      case .primary, .secondary:
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.backgroundColor = .systemGroupedBackground
        let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
        section.contentInsets = NSDirectionalEdgeInsets(top: verticalSpacing, leading: horizontalSpacing, bottom: verticalSpacing, trailing: horizontalSpacing)
        return section
      case .large:
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.backgroundColor = .systemGroupedBackground
        configuration.showsSeparators = false
        
        let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
        section.contentInsets = NSDirectionalEdgeInsets(top: verticalSpacing, leading: horizontalSpacing, bottom: verticalSpacing, trailing: horizontalSpacing)
        return section
      case .headline:
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
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(
            elementKind: GroupListDataSource.sectionBackgroundDecorationElementKind)
        section.decorationItems = [sectionBackgroundDecoration]
        return section
      }
    }
    return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
  }
}

// MARK: - CollectionViewDelegate
extension GroupListDataSource: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    guard let content = dataSource.itemIdentifier(for: indexPath) as? ContentCardable, content.isContentCard else { return }
    
    content.logContentCardImpression()
  }
}
