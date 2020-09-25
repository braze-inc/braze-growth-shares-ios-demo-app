import UIKit

class HomeListViewController: UIViewController {
    
  // MARK: - Outlets
  @IBOutlet private weak var collectionView: UICollectionView!
  @IBOutlet private weak var shoppingCartButtonItem: UIBarButtonItem!
  @IBOutlet private var dataSource: HomeListDataSource!
  
  // MARK: - Variables
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
    
    configureObservers()
    configureRefreshControl()
    
    downloadContent()
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
    HomeListOperationQueue().downloadContent { [weak self] (items, ads) in
      guard let self = self else { return }
      
      DispatchQueue.main.async {
        self.dataSource.setDataSource(with: items, ads: ads, delegate: self)
        self.reloadCollectionView()
      }
    }
  }
  
  @objc func refresh(_ sender: Any) {
    downloadContent()
  }
  
  @objc func reorder(_ sender: Any) {
    dataSource.reorderDataSource()
    reloadCollectionView()
  }
  
  @objc func reset(_ sender: Any) {
    dataSource.resetDataSource()
    reloadCollectionView()
  }
  
  func reloadCollectionView() {
    collectionView.performBatchUpdates {
      self.collectionView.reloadSections(IndexSet(integer: 0))
    } completion: { _ in
      self.refreshControl.endRefreshing()
    }
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

