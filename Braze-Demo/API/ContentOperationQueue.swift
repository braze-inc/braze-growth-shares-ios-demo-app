import Foundation

class ContentOperationQueue: OperationQueue {
  private var contentCardCompletionHandler: ([ContentCardable]) -> () = { _ in }
  private let semaphore = DispatchSemaphore(value: 0)
  private var classTypes = [ContentCardClassType]()
  
  required init(classTypes: [ContentCardClassType]) {
    self.classTypes = classTypes
  }
  
  /// The observer in this case is `ContentOperationQueue`. The observer needs to be retained in memory long enough to recieve the initial `contentCardsUpdated(_ notification: Notification)` callback.
  func loadContentCards() {
    BrazeManager.shared.addObserverForContentCards(observer: self, selector: #selector(contentCardsUpdated))
    BrazeManager.shared.requestContentCardsRefresh()
  }
  
  @objc private func contentCardsUpdated(_ notification: Notification) {
    let contentCards = BrazeManager.shared.handleContentCardsUpdated(notification, for: classTypes)
    contentCardCompletionHandler(contentCards)
    
    semaphore.signal()
  }
}

// MARK: - Public
extension ContentOperationQueue {
  /// One way to load data at once from different sources (i.e. data from a local file and data from a Braze endpoint).
  ///
  ///A `BarrierBlock` is responsible for calling the completion handler when both loading operations are completed. A semaphore is used when working with an `Operation` object to signal that Content Cards are loaded due to the nature of the Notifcation callback.
  /// - parameter content: ContentCardable objects loaded from a local file and from Content Cards.
  /// - parameter ads: Ad objects loaded from Content Cards.
  func downloadContent() async -> HomeMetaData {
    var meta: HomeMetaData = await loadMetaData()
    
    contentCardCompletionHandler = { contentCards in
      for card in contentCards {
        switch card.contentCardData?.contentCardClassType {
        case .home(.pill):
          meta.data[0].attributes.pills += [card as! HomeItem]
        case .home(.bottle):
          meta.data[0].attributes.bottles += [card as! HomeItem]
        case .home(.miniBottle):
          let miniBottle = card as! HomeItem
          for i in 0..<meta.data[0].attributes.composites.count {
            if meta.data[0].attributes.composites[i].compositeID == miniBottle.compositeID {
              meta.data[0].attributes.composites[i].miniBottles.append(miniBottle)
            }
          }
        default: break
        }
      }
    }
    
    addOperation { [weak self] in
      guard let self = self else { return }
      self.loadContentCards()
      if self.semaphore.wait(timeout: .now() + 5) == .timedOut {
        return
      }
    }
    
    return await withCheckedContinuation { continuation in
      addBarrierBlock {
        continuation.resume(returning: (meta))
      }
    }
  }
}

// MARK: - Private
private extension ContentOperationQueue {
  func loadMetaData() async -> HomeMetaData {
    do {
      return try await NetworkRequest.makeRequest()
    } catch {
      return HomeMetaData.empty
    }
  }
}
