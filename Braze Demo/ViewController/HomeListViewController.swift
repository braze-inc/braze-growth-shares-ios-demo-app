import UIKit

class HomeListViewController: UIViewController {
    
  // MARK: - Outlets
  @IBOutlet private weak var collectionView: UICollectionView! {
    didSet {
      provider = HomeListDataSourceProvider(collectionView: collectionView, delegate: self)
    }
  }
  @IBOutlet private weak var shoppingCartButtonItem: UIBarButtonItem!
  
  // MARK: - Variables
  private var provider: HomeListDataSourceProvider?
  private var shoppingCartItems: [Tile] = [] {
      didSet {
          guard let cartButtonItem = shoppingCartButtonItem else { return }
            
          cartButtonItem.image = shoppingCartItems.isEmpty ? UIImage(systemName: "cart") : UIImage(systemName: "cart.fill")
      }
  }
  private let sheetVc = SheetViewController.fromNib()
  private let refreshControl = UIRefreshControl()
  private let cartSegueIdentifier = "segueToCart"
}

// MARK: - View Lifecycle
extension HomeListViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureObservers()
    configureRefreshControl()
    
    downloadContent()
    
    sheetVc.addSheet(to: self)
  }
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == cartSegueIdentifier, let shoppingCartVc = segue.destination as? ShoppingCartViewController else { return }
        
      shoppingCartVc.configure(with: shoppingCartItems, delegate: self)
  }
}

// MARK: - Private Methods
private extension HomeListViewController {
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
    let contentOperationQueue = ContentOperationQueue<Tile, TileList>(localDataFile: "Local Data", classType: .item(.tile))
    contentOperationQueue.downloadContent { [weak self] (content, ads) in
      guard let self = self else { return }
      
      DispatchQueue.main.async {
        self.provider?.applySnapshot(content, ads)
        self.refreshControl.endRefreshing()
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
    
    sheetVc.animatePoint(.slideUp)
  }
}

// MARK: - SheetView Action Delegate
extension HomeListViewController: SheetViewActionDelegate {
  func sheetViewDidDismiss() {
    sheetVc.removeFromParent()
  }
}
