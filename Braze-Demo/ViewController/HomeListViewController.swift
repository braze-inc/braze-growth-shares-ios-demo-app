import UIKit

class HomeListViewController: UIViewController {
    
  @IBOutlet private weak var shoppingCartButtonItem: UIBarButtonItem!
  
  // MARK: - Variables
  private var shoppingCartItems: [Tile] = [] {
      didSet {
          guard let cartButtonItem = shoppingCartButtonItem else { return }
            
          cartButtonItem.image = shoppingCartItems.isEmpty ? UIImage(systemName: "cart") : UIImage(systemName: "cart.fill")
      }
  }
  private let cartSegueIdentifier = "segueToCart"
}

// MARK: - View Lifecycle
extension HomeListViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
  }
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == cartSegueIdentifier, let shoppingCartVc = segue.destination as? ShoppingCartViewController else { return }
        
    shoppingCartVc.configure(with: shoppingCartItems, delegate: self)
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
//    guard let tile = item as? Tile else { return }
//
//    if tile.isContentCard {
//      tile.logContentCardClicked()
//    }
//    BrazeManager.shared.logCustomEvent("Added item to cart")
//    shoppingCartItems.append(tile)
//    presentAlert(title: "Added \(tile.title) to Shopping Cart", message: nil)
  }
}
