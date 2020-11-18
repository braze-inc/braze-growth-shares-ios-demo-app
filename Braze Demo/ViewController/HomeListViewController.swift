import UIKit

enum HomeScreenType: Int {
  case tile
  case group
}

class HomeListViewController: UIViewController {
    
  // MARK: - Outlets
  @IBOutlet private weak var collectionView: UICollectionView!
  @IBOutlet private weak var shoppingCartButtonItem: UIBarButtonItem!
  
  // MARK: - Variables
  private let homeScreenMenuView: HomeScreenMenuView = .fromNib()
  private var homeScreenType: HomeScreenType = .group {
    didSet {
      configureHomeScreen()
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
    
    configureNavigationButton()
    configureObservers()
    configureRefreshControl()
    configureHomeScreen()
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
      super.viewWillTransition(to: size, with: coordinator)
      coordinator.animate(alongsideTransition: nil) { _ in
        self.collectionView.reloadData()
      }
  }
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == cartSegueIdentifier, let shoppingCartVc = segue.destination as? ShoppingCartViewController else { return }
        
      shoppingCartVc.configure(with: shoppingCartItems, delegate: self)
  }
}

// MARK: - Private Methods
private extension HomeListViewController {
  func configureHomeScreen() {
    switch homeScreenType {
    case .tile:
      view.backgroundColor = .lightGray
      collectionView.dataSource = nil
      provider = TileListDataSource(collectionView: collectionView, delegate: self)
    case .group:
      view.backgroundColor = .systemGreen
      collectionView.dataSource = nil
      provider = GroupListDataSource(collectionView: collectionView, delegate: self)
    }

    downloadContent()
  }
  
  func configureNavigationButton() {
    let button = UIButton(type: .custom)
    button.setTitle("Home ▼", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
    button.addTarget(self, action: #selector(titlePressed(_:)), for: .touchUpInside)
    navigationItem.titleView = button
    
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
  
  func downloadContent() {
    switch homeScreenType {
    case .tile:
      let contentOperationQueue = ContentOperationQueue<Tile, TileList>(localDataFile: "Tile List", classType: .item(.tile))
      contentOperationQueue.downloadContent { [weak self] (content, ads) in
        guard let self = self else { return }
        
        DispatchQueue.main.async {
          self.provider?.applySnapshot(content, ads: ads, animatingDifferences: true)
          self.refreshControl.endRefreshing()
        }
      }
    case .group:
      let contentOperationQueue = ContentOperationQueue<Group, GroupList>(localDataFile: "Group List", classType: .item(.group))
      contentOperationQueue.downloadContent { [weak self] (content, ads) in
        guard let self = self else { return }
        
        DispatchQueue.main.async {
          self.provider?.applySnapshot(content, ads: ads, animatingDifferences: true)
          self.refreshControl.endRefreshing()
        }
      }
    }
  }
  
  @objc func refresh(_ sender: Any) {
    downloadContent()
  }
  
  @objc func reorder(_ sender: Any) {
    provider?.reorderDataSource()
  }

  @objc func reset(_ sender: Any) {
    provider?.resetDataSource()
    downloadContent()
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

extension HomeListViewController: HomeScreenMenuViewActionDelegate {
  func menuButtonPressed(atIndex index: Int) {
    homeScreenType = HomeScreenType(rawValue: index) ?? .tile
    homeScreenMenuView.isHidden = true
  }
}

