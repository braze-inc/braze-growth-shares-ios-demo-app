import UIKit

class GroupListDataSource: NSObject, CollectionViewDataSourceProvider {
  typealias DataSource = UICollectionViewDiffableDataSource<GroupSection, AnyHashable>
  typealias Snapshot = NSDiffableDataSourceSnapshot<GroupSection, AnyHashable>
  
  // MARK: - Variables
  private var dataSource: DataSource!
  private weak var delegate: CellActionDelegate?
  
  required init(collectionView: UICollectionView, delegate: CellActionDelegate) {
    super.init()
    self.delegate = delegate
   
    collectionView.register(HeaderSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderSupplementaryView.reuseIdentifier)
    collectionView.register(FooterSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterSupplementaryView.reuseIdentifier)
    
    configureDataSource(collectionView)
    configureHeaderFooter()
    
    collectionView.collectionViewLayout = configureLayout()
    collectionView.collectionViewLayout.register(SectionBackgroundDecorationView.self,forDecorationViewOfKind: GroupedLayoutBuilder.sectionBackgroundDecorationElementKind)
    
    collectionView.delegate = self
  }
  
  func applySnapshot(_ content: [ContentCardable], ads: [Ad], animatingDifferences: Bool) {
    guard content is [Group] else { return }
    
    var snapshot = Snapshot()
    
    snapshot.appendSections(GroupSection.allCases)
    snapshot.appendItems(["Blank"], toSection: .blank)
    snapshot.appendItems(ads, toSection: .ad)
    
    let groups = content as! [Group]
    groups.forEach {
      switch $0.style {
      case .primary:
        snapshot.appendItems([$0], toSection: .primary)
      case .secondary:
        snapshot.appendItems([$0], toSection: .secondary)
      case .headline:
        snapshot.appendItems([$0], toSection: .headline)
      case .largeRow:
        snapshot.appendItems([$0], toSection: .large)
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
      case let group as Group:
        switch GroupSection(rawValue: indexPath.section) {
        case .primary, .secondary:
          return collectionView.dequeueConfiguredReusableCell(using: SmallRowCollectionViewCell.configuredCell(), for: indexPath, item: group)
        case .headline:
          return collectionView.dequeueConfiguredReusableCell(using: HeadlineCollectionViewCell.configuredCell(), for: indexPath, item: group)
        case .large:
          let cell: LargeRowCollectionViewCell! = collectionView.dequeueReusablCell(for: indexPath)
          cell.configureCell(group.title, imageUrl: group.imageUrl)
          return cell
        default: return UICollectionViewCell()
        }
      default: return UICollectionViewCell()
      }
    }
  }
  
  func configureHeaderFooter() {
    dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
      if kind == UICollectionView.elementKindSectionHeader {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderSupplementaryView.reuseIdentifier, for: indexPath) as? HeaderSupplementaryView
        header?.label.text = "Learning Materials"
        return header
      } else if kind == UICollectionView.elementKindSectionFooter {
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterSupplementaryView.reuseIdentifier, for: indexPath) as? FooterSupplementaryView
      } else {
        return nil
      }
    }
  }
  
  func configureLayout() -> UICollectionViewLayout {
    let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
    
      guard let section = GroupSection(rawValue: sectionIndex) else { return nil }
      
      switch section {
      case .ad:
        return GroupedLayoutBuilder.buildAdLayoutSection(layoutEnvironment: layoutEnvironment)
      case .blank:
        return GroupedLayoutBuilder.buildBlankLayoutSection()
      case .primary, .secondary:
        return GroupedLayoutBuilder.buildSmallRowLayoutSection(layoutEnvironment: layoutEnvironment)
      case .large:
        return GroupedLayoutBuilder.buildLargeRowLayoutSection()
      case .headline:
        return GroupedLayoutBuilder.buildHeadlineLayoutSection(layoutEnvironment: layoutEnvironment)
      }
    }
    return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
  }
}

// MARK: - CollectionViewDelegate
extension GroupListDataSource: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    guard let content = dataSource.itemIdentifier(for: indexPath) as? ContentCardable, content.isContentCard else { return }
    
    content.logContentCardClicked()
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    guard let content = dataSource.itemIdentifier(for: indexPath) as? ContentCardable, content.isContentCard else { return }
    
    content.logContentCardImpression()
  }
}
