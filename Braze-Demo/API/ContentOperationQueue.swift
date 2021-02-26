import Foundation

class ContentOperationQueue<T: ContentCardable, U: MetaData>: OperationQueue {
  private var localContentCompletionHandler: ([U.Element]) -> () = { _ in }
  private var contentCardCompletionHandler: ([ContentCardable]) -> () = { _ in }
  private let semaphore = DispatchSemaphore(value: 0)
  private var classType: ContentCardClassType = .none
  private var localDataFile: String?
  private lazy var result: APIResult<U> = {
    guard let file = localDataFile else { return .failure("No Local Data File Provided") }
    return LocalDataCoordinator().loadData(fileName: file, withExtension: "json")
  }()
  
  init(localDataFile: String?, classType: ContentCardClassType) {
    self.localDataFile = localDataFile
    self.classType = classType
  }
  
  /// The observer in this case is `ContentOperationQueue`. The observer needs to be retained in memory long enough to recieve the initial `contentCardsUpdated(_ notification: Notification)` callback.
  func loadContentCards() {
    BrazeManager.shared.addObserverForContentCards(observer: self, selector: #selector(contentCardsUpdated))
    BrazeManager.shared.requestContentCardsRefresh()
  }
  
  @objc private func contentCardsUpdated(_ notification: Notification) {
    let contentCards = BrazeManager.shared.handleContentCardsUpdated(notification, for: [classType, .ad])
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
  func downloadContent(_ completion: @escaping (_ content: [T], _ ads: [Ad]) -> ()) {
    var content = [T]()
    var ads = [Ad]()
    
    contentCardCompletionHandler = { contentCards in
      for card in contentCards {
        if card is Ad {
          ads.append(card as! Ad)
        } else if card is T {
          content.insert(card as! T, at: 0)
        }
      }
    }
    
    localContentCompletionHandler = { localContent in
      content.append(contentsOf: localContent as! [T])
    }
    
    addOperation { [weak self] in
      guard let self = self else { return }
      self.loadLocalContent(self.localContentCompletionHandler)
    }
    
    addOperation { [weak self] in
      guard let self = self else { return }
      self.loadContentCards()
      self.semaphore.wait()
    }
    
    addBarrierBlock {
      completion(content, ads)
    }
  }
}

// MARK: - Private
private extension ContentOperationQueue {
  func loadLocalContent(_ completion: @escaping ([U.Element]) -> ()) {
    switch result {
    case .success(let metaData):
      completion(metaData.items)
    case .failure:
      cancelAllOperations()
    }
  }
}
