import UIKit

protocol CellActionDelegate: class {
    func cellTapped(with data: Any?)
}

enum CollectionViewSection: Int {
  case ad
  case tile
}

class HomeListDataSourceProvider: NSObject {
  private typealias DataSource = UICollectionViewDiffableDataSource<CollectionViewSection, AnyHashable>
  private typealias Snapshot = NSDiffableDataSourceSnapshot<CollectionViewSection, AnyHashable>
  
  // MARK: - Variables
  private var dataSource: DataSource!
  private weak var delegate: CellActionDelegate?
  
  required init(collectionView: UICollectionView, delegate: CellActionDelegate? = nil) {
    super.init()
    self.delegate = delegate
   
    configureLayout(collectionView)
    configureDataSource(collectionView)
    
    collectionView.delegate = self
  }
  
  func applySnapshot(_ tiles: [Tile], _ ads: [Ad], animatingDifferences: Bool = true) {
    var snapshot = Snapshot()
    
    snapshot.appendSections([.ad, .tile])
    
    snapshot.appendItems(ads, toSection: .ad)
    snapshot.appendItems(reorderTiles(tiles), toSection: .tile)
    
    dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
  }
  
  func reorderDataSource() {
    guard let tiles = dataSource.snapshot(for: .tile).items as? [Tile] else { return }
      
    var tileSnapshot = dataSource.snapshot(for: .tile)
    tileSnapshot.deleteAll()
    
    tileSnapshot.append(reorderTiles(tiles))
    
    dataSource.apply(tileSnapshot, to: .tile, animatingDifferences: true, completion: nil)
  }
  
  func resetDataSource() {
    dataSource.snapshot(for: .tile).items.forEach { content in
      guard let tile = content as? Tile, tile.isContentCard else { return }
      
      tile.logContentCardDismissed()
    }
  }
}

// MARK: - Private
private extension HomeListDataSourceProvider {
  func configureDataSource(_ collectionView: UICollectionView) {
    dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, content) -> UICollectionViewCell? in
      
      switch content {
      case let ad as Ad:
        let cell: BannerAdCollectionViewCell! = collectionView.dequeueReusablCell(for: indexPath)
        cell.configureCell(ad.imageUrl)
        return cell
      case let tile as Tile:
        let cell: ItemCollectionViewCell! = collectionView.dequeueReusablCell(for: indexPath)
        cell.configureCell(tile.title, tile.detail, tile.price, tile.imageUrl)
        return cell
      default:
        return UICollectionViewCell()
      }
    })
  }
  
  func configureLayout(_ collectionView: UICollectionView) {
    collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
      
      guard let section = CollectionViewSection(rawValue: sectionIndex) else { return nil }
      
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
        section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: 0, trailing: spacing)
        return section
      case .tile:
        let itemCount = isPhone ? 1 : 2
              
        let width = (collectionView.frame.size.width - spacing) / CGFloat(itemCount)
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
    })
  }
  
  func reorderTiles(_ tiles: [Tile]) -> [Tile] {
    guard let priority = RemoteStorage().retrieve(forKey: RemoteStorageKey.homeListPriority.rawValue) as? String, !priority.isEmpty else { return tiles }
    
    let priorityKeys = priority.separatedByCommaSpaceValue
    
    var priorityTiles = [Tile]()
    var tiles = tiles
        
    for (index, tile) in tiles.enumerated().reversed() {
      if !tile.tags.intersection(priorityKeys).isEmpty {
        tiles.remove(at: index)
        if tile.isContentCard {
          priorityTiles.insert(tile, at: 0)
        } else {
          priorityTiles.append(tile)
        }
      }
    }
    return priorityTiles + tiles
  }
}

// MARK: - CollectionViewDelegate
extension HomeListDataSourceProvider: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let tile = dataSource.itemIdentifier(for: indexPath) as? Tile else { return }
    
    delegate?.cellTapped(with: tile)
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    guard let content = dataSource.itemIdentifier(for: indexPath) as? ContentCardable, content.isContentCard else { return }
    
    content.logContentCardImpression()
  }
}
