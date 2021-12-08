import UIKit
import SwiftUI

class HomeListViewController: UIViewController {
    
  // MARK: - Outlets
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
    
    configureHomeScreen()
  }
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == cartSegueIdentifier, let shoppingCartVc = segue.destination as? ShoppingCartViewController else { return }
        
    shoppingCartVc.configure(with: shoppingCartItems, delegate: self)
  }
}

// MARK: - Private
private extension HomeListViewController {
  func configureHomeScreen() {
    let homeView = UIHostingController(rootView: HomeView())
    addChild(homeView)
    view.addSubview(homeView.view)
    
    homeView.view.translatesAutoresizingMaskIntoConstraints = false
    homeView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    homeView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    homeView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    homeView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
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
