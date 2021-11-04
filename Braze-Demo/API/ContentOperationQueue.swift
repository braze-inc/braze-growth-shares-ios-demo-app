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
  func downloadContent() async -> HomeData {
    var homeData: HomeData = loadLocalContent()
    
    contentCardCompletionHandler = { contentCards in
     
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
        continuation.resume(returning: (homeData))
      }
    }
  }
}

// MARK: - Private
private extension ContentOperationQueue {
  func loadLocalContent() -> HomeData {
    do {
      return try LocalDataCoordinator().loadData(fileName: "Home-List", withExtension: "json")
    } catch {
      return HomeData(pills: [], bottles: [], composites: [])
    }
  }
}
