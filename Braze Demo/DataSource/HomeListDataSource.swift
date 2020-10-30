import UIKit

private enum RowType {
  case ad(Ad)
  case item(Tile)
}

protocol CellActionDelegate: class {
    func cellTapped(with data: Any?)
}

class HomeListDataSource: NSObject {
  
  // MARK: - HomeListContext
  struct HomeListContext {
    private(set) var ads: [Ad]
    var tiles: [Tile]
    private(set) var adSpacer = 2
  }
    
  // MARK: - Variables
  private var context: HomeListContext! {
    didSet {
      reorderDataSource()
    }
  }
  private weak var delegate: CellActionDelegate?
  private var rows: [RowType] = []
  private var orderedTiles: [Tile] = [] {
    didSet {
      formatRows(orderedTiles, adSpacer: context.adSpacer)
    }
  }
}

// MARK: - Public Methods
extension HomeListDataSource {
  func setDataSource(with tiles: [Tile], ads: [Ad], delegate: CellActionDelegate? = nil) {
      self.context = HomeListContext(ads: ads, tiles: tiles)
      self.delegate = delegate
  }
  
  func reorderDataSource() {
    guard let context = context else { return }
    
    if let priorityKeys = RemoteStorage().retrieve(forKey: RemoteStorageKey.homeListPriority.rawValue) as? String, !priorityKeys.isEmpty {
      orderedTiles = reorderTiles(context.tiles, with: priorityKeys.separatedByCommaSpaceValue)
    } else {
      orderedTiles = context.tiles
    }
  }
  
  /// Removes any Content Cards in the home feed and resets the order to its default order.
  func resetDataSource() {
    for tile in context.tiles {
      if tile.isContentCard {
        deleteItem(tile)
      }
    }
    orderedTiles = context.tiles
  }
  
  func deleteItem(_ itemToDelete: Tile) {
    itemToDelete.logContentCardDismissed()
    
    context.tiles = context.tiles.filter { $0.contentCardData?.contentCardId != itemToDelete.contentCardData?.contentCardId }
  }
  
  func indexPath(for tile: Tile) -> IndexPath? {
    guard let index = context.tiles.firstIndex(of: tile) else { return nil }
    return IndexPath(item: index, section: 0)
  }
}

// MARK: - Private Methods
private extension HomeListDataSource {
  /// Reorders the tiles by looping through each `priorityKey` and bubbling up each `Tile` with a `tag`that matches.
  ///
  /// If there are no keys, the order will be unchanged.
  /// - parameter tiles: Array to be reordered.
  /// - parameter priorityKeys: Array of keys used to determine the order of the tiles. The order of the keys in the array is used to determine the order of the tiles.
  func reorderTiles(_ tiles: [Tile], with priorityKeys: [String]) -> [Tile] {
    var allPriorityTiles = [Tile]()
    var tiles = tiles
    
    for priority in priorityKeys {
      var priorityTiles = [Tile]()
      for (index, tile) in tiles.enumerated().reversed() {
        if tile.tags.contains(priority) {
          tiles.remove(at: index)
          if tile.isContentCard {
            priorityTiles.insert(tile, at: 0)
          } else {
            priorityTiles.append(tile)
          }
        }
      }
      allPriorityTiles.append(contentsOf: priorityTiles)
    }
    return allPriorityTiles + tiles
  }
  
  /// Formats the `Tile` objects to be added to an array of the enum `RowType`. Dynamically inserting an `Ad` object based on the `adSpacer` variable.
  /// - parameter tiles: Array to be added to the formatted `rows` array.
  /// - parameter adSpacer: Spacer that is used to determine when an ad should be dynamically inserted into the list. For example, if the adSpacer = 2, there will be an inline ad inserted every 2 tiles.
  func formatRows(_ tiles: [Tile], adSpacer: Int) {
    guard !tiles.isEmpty else { return self.rows = [] }
    
    var rows = [RowType]()
    var adIndex = 0
    
    for i in 0..<tiles.count {
      let tile = tiles[i]
      
      if context.adSpacer > 0 {
        if i % adSpacer == 0, let ad = adToDisplay(at: adIndex) {
          rows.append(.ad(ad))
          adIndex += 1
        }
      }
      
      rows.append(.item(tile))
    }
    if adSpacer > 0, let ad = adToDisplay(at: adIndex) {
      rows.append(.ad(ad))
    }
    
    self.rows = rows
  }
  
  /// Determines what `Ad` to display from the `HomeListContext` `Ads` array.
  /// - parameter index: Used to query what ad in the ads array to display. If the index is greater than the amount of ads, the next ad to be displayed will start back at index 0.
  func adToDisplay(at index: Int) -> Ad? {
    guard !context.ads.isEmpty else { return nil }
    return context.ads[(index % context.ads.count + context.ads.count) % context.ads.count]
  }
}

// MARK: - Delegate
extension HomeListDataSource: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      switch rows[indexPath.row] {
      case .item(let tile):
        delegate?.cellTapped(with: tile)
      case .ad:
        break
      }
    }
}

// MARK: - DataSource
extension HomeListDataSource: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return rows.count
  }
    
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch rows[indexPath.row] {
    case .item(let tile):
      let cell: ItemCollectionViewCell! = collectionView.dequeueReusablCell(for: indexPath)
      cell.configureCell(tile.title, tile.detail, tile.price, tile.imageUrl)
      return cell
    case .ad(let ad):
      let cell: BannerAdCollectionViewCell! = collectionView.dequeueReusablCell(for: indexPath)
      cell.configureCell(ad.imageUrl)
      return cell
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    switch rows[indexPath.row] {
    case .item(let tile):
      guard tile.isContentCard else { break }
      tile.logContentCardImpression()
    case .ad(let ad):
      guard ad.isContentCard else { break }
      ad.logContentCardImpression()
    }
  }
}

// MARK: - FlowLayout
extension HomeListDataSource: UICollectionViewDelegateFlowLayout {
  private var cellSpacing: CGFloat { return 10.0 }
  private var sectionSpacing: CGFloat { return 10.0 }
    
  private var sizeSpacing: CGFloat {
      return (cellSpacing + (sectionSpacing * 2)) / 2
  }
    
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.size.width - (sectionSpacing * 2)
    switch rows[indexPath.row] {
    case .item:
      let height: CGFloat = (width/500 * 282) + 150
      return CGSize(width: width, height: height)
    case .ad:
      let height: CGFloat = (width/394 * 100)
      return CGSize(width: width, height: height)
    }
  }
    
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      return UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
  }
    
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return cellSpacing
  }
}
