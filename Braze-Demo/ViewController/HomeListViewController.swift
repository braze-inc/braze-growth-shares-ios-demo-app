import UIKit

enum HomeScreenType: Int {
  case tile
  case group
}

class HomeListViewController: UIViewController {
    
  // MARK: - Outlets
  @IBOutlet private weak var collectionView: UICollectionView!
  @IBOutlet private weak var headerImageView: UIImageView!
  @IBOutlet private weak var shoppingCartButtonItem: UIBarButtonItem!
  
  // MARK: - Variables
  private let homeScreenMenuView: HomeScreenMenuView = .fromNib()
  private var homeScreenType: HomeScreenType = .tile {
    didSet {
      configureCollectionView(by: homeScreenType)
    }
  }
  private var provider: CollectionViewDataSourceProvider?
  private var shoppingCartItems: [Tile] = [] {
      didSet {
          guard let cartButtonItem = shoppingCartButtonItem else { return }
            
          cartButtonItem.image = shoppingCartItems.isEmpty ? UIImage(systemName: "cart") : UIImage(systemName: "cart.fill")
      }
  }
  private let refreshControl = UIRefreshControl()
  private let cartSegueIdentifier = "segueToCart"
}

// MARK: - View Lifecycle
extension HomeListViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureHomeScreen()
  }
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == cartSegueIdentifier, let shoppingCartVc = segue.destination as? ShoppingCartViewController else { return }
        
      shoppingCartVc.configure(with: shoppingCartItems, delegate: self)
  }
}

// MARK: - Private Methods
private extension HomeListViewController {
  func configureHomeScreen() {
    configureObservers()
    configureNavigationButton()
    configureHomeScreenMenuView()
    configureRefreshControl()
    configureHomeScreenType()
  }
  
  func configureNavigationButton() {
    navigationItem.titleView = UIButton.navigationButton(title: "Home ▼", target: self, selector: #selector(titlePressed(_:)))
  }
  
  func configureHomeScreenMenuView() {
    homeScreenMenuView.configureDelegate(self)
    homeScreenMenuView.isHidden = true
    view.addSubview(homeScreenMenuView)
    
    homeScreenMenuView.translatesAutoresizingMaskIntoConstraints = false
    let verticalConstraint = homeScreenMenuView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 0.0)
    let horizontalConstraint = NSLayoutConstraint(item: homeScreenMenuView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
    let heightConstraint = NSLayoutConstraint(item: homeScreenMenuView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 125.0)
    let widthConstraint = NSLayoutConstraint(item: homeScreenMenuView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 250.0)
    view.addConstraints([verticalConstraint, horizontalConstraint, heightConstraint, widthConstraint])
  }
  
  func configureObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(reorder(_:)), name: .reorderHomeScreen, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(refresh(_:)), name: .homeScreenContentCard, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(reset(_:)), name: .defaultAppExperience, object: nil)
  }
  
  func configureRefreshControl() {
    refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    collectionView.refreshControl = refreshControl
  }
  
  func configureHomeScreenType() {
    guard let index = RemoteStorage().retrieve(forKey: .homeScreenType) as? Int else { return homeScreenType = .tile }

    homeScreenType = HomeScreenType(rawValue: index) ?? .tile
  }
}
  
// MARK: - Dynamic Home List
private extension HomeListViewController {
  func configureCollectionView(by homeScreenType: HomeScreenType) {
    collectionView.dataSource = nil
    
    switch homeScreenType {
    case .tile:
      tileCollectionViewConfiguration()
    case .group:
      groupCollectionViewConfiguration()
    }
    
    configureAndProcessDownload(by: homeScreenType)
  }
  
  func tileCollectionViewConfiguration() {
    shoppingCartButtonItem.isEnabled = true
    headerImageView.isHidden = true
    view.backgroundColor = .systemGroupedBackground
    provider = TileListDataSource(collectionView: collectionView, delegate: self)
  }
  
  func groupCollectionViewConfiguration() {
    shoppingCartButtonItem.isEnabled = false
    headerImageView.isHidden = false
    view.backgroundColor = .systemGreen
    provider = GroupListDataSource(collectionView: collectionView, delegate: self)
  }
  
  func configureAndProcessDownload(by homeScreenType: HomeScreenType) {
    switch homeScreenType {
    case .tile:
      downloadContent(Tile.self, TileList.self, fileName: "Tile-List", classType: .item(.tile))
    case .group:
      downloadContent(Group.self, GroupList.self, fileName: "Group-List", classType: .item(.group))
    }
  }
  
  func downloadContent<T: ContentCardable, U: MetaData>(_ content: T.Type, _ metaData: U.Type, fileName: String, classType: ContentCardClassType) {
    let contentOperationQueue = ContentOperationQueue<T, U>(localDataFile: fileName, classType: classType)
    contentOperationQueue.downloadContent { [weak self] (content, ads) in
      guard let self = self else { return }
      
      DispatchQueue.main.async {
        self.provider?.applySnapshot(content, ads: ads, animatingDifferences: true)
        self.refreshControl.endRefreshing()
      }
    }
  }
  
  @objc func refresh(_ sender: Any) {
    configureAndProcessDownload(by: homeScreenType)
  }
  
  @objc func reorder(_ sender: Any) {
    provider?.reorderDataSource()
  }

  @objc func reset(_ sender: Any) {
    provider?.resetDataSource()
    configureAndProcessDownload(by: homeScreenType)
  }
  
  @objc func titlePressed(_ sender: Any) {
    homeScreenMenuView.isHidden.toggle()
  }
}

// MARK: - ShoppingCartDelegate
extension HomeListViewController: ShoppingCartActionDelegate {
  func emptiedCart() {
    shoppingCartItems.removeAll()
  }
}

// MARK: - CellActionDelegate
extension HomeListViewController: CellActionDelegate {
  func cellTapped(with item: Any?) {
    guard let tile = item as? Tile else { return }
    
    if tile.isContentCard {
      tile.logContentCardClicked()
    }
    AppboyManager.shared.logCustomEvent("Added item to cart")
    shoppingCartItems.append(tile)
    presentAlert(title: "Added \(tile.title) to Shopping Cart", message: nil)
  }
}

// MARK: - Home Screen Menu Delegate
extension HomeListViewController: HomeScreenMenuViewActionDelegate {
  func menuButtonPressed(atIndex index: Int) {
    defer { homeScreenMenuView.isHidden = true }
    
    guard index != homeScreenType.rawValue else { return }
    
    homeScreenType = HomeScreenType(rawValue: index) ?? .tile
    RemoteStorage().store(index, forKey: .homeScreenType)
  }
}
