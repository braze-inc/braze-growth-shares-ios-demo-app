import Foundation

class HomeListOperationQueue: OperationQueue {
  private var tile: ([Tile]) -> () = { _ in }
  private var contentCardCompletionHandler: ([ContentCardable]) -> () = { _ in }
  private let semaphore = DispatchSemaphore(value: 0)
  private lazy var result: APIResult<TileList> = {
      return LocalDataCoordinator().loadData(fileName: "Local Data", withExtension: "json")
  }()
}

// MARK: - Public
extension HomeListOperationQueue {
  /// One way to load data at once from different sources (i.e. data from a local file and data from a Braze endpoint).
  ///
  ///A `BarrierBlock` is responsible for calling the completion handler when both loading operations are completed. A semaphore is used when working with an `Operation` object to signal that Content Cards are loaded due to the nature of the Notifcation callback.
  /// - parameter tiles: Tile objects loaded from a local file and from Content Cards.
  /// - parameter ads: Ad objects loaded from Content Cards.
  func downloadContent(_ completion: @escaping (_ tiles: [Tile], _ ads: [Ad]) -> ()) {
    var tiles = [Tile]()
    var ads = [Ad]()
    
    contentCardCompletionHandler = { contentCards in
      for card in contentCards {
        if card is Ad {
          ads.append(card as! Ad)
        } else if card is Tile {
          tiles.insert(card as! Tile, at: 0)
        }
      }
    }
    
    tile = { localTiles in
      tiles.append(contentsOf: localTiles)
    }
    
    addOperation { [weak self] in
      guard let self = self else { return }
      self.loadTiles(self.tile)
    }
    
    addOperation { [weak self] in
      guard let self = self else { return }
      self.loadContentCards()
      self.semaphore.wait()
    }
    
    addBarrierBlock {
      completion(tiles, ads)
    }
  }
}

// MARK: - Private
private extension HomeListOperationQueue {
  func loadTiles(_ completion: @escaping ([Tile]) -> ()) {
      switch result {
      case .success(let metaData):
        completion(metaData.tiles)
      case .failure:
        cancelAllOperations()
    }
  }
  
  /// The observer in this case is `HomeListOperationQueue`. The observer needs to be retained in memory long enough to recieve the initial `contentCardsUpdated(_ notification: Notification)` callback.
  func loadContentCards() {
    AppboyManager.shared.addObserverForContentCards(observer: self, selector: #selector(contentCardsUpdated))
    AppboyManager.shared.requestContentCardsRefresh()
  }
  
  @objc private func contentCardsUpdated(_ notification: Notification) {
    let contentCards = AppboyManager.shared.handleContentCardsUpdated(notification, for: [.item(.tile), .ad])
    contentCardCompletionHandler(contentCards)
    semaphore.signal()
  }
}
