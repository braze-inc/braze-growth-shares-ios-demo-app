import UIKit

protocol ShoppingCartActionDelegate: class {
  func emptiedCart()
}

class ShoppingCartViewController: UIViewController {
    
  // MARK: - Outlets
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var purchaseButton: UIButton!
  @IBOutlet private weak var emptyCartButton: UIButton!
  @IBOutlet private var dataSource: ShoppingCartDataSource!
  private var gestureView: ContentCardGestureView?
  private var coupon: Coupon?
    
  // MARK: - Actions
  @IBAction func purchaseTapped(_ sender: Any) {
    purchaseItems()
    emptyCart(logEvent: false)
  }
  @IBAction func emptyCartTapped(_ sender: Any) {
    emptyCart(logEvent: true)
  }
  @IBAction func exitButtonTapped(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
    
  // MARK: - Variables
  private var items: [Tile] = [] {
    didSet {
      configurePurchaseButton(isCartEmpty: isCartEmpty)
      dataSource.configure(with: items)
      tableView?.reloadData()
    }
  }
  private var isCartEmpty: Bool { return items.isEmpty }
  private var totalPrice: Decimal {
    var sum: Decimal = 0.00
    items.forEach { sum += $0.price ?? 0.00 }
    return sum * (coupon?.discountMultipler ?? 1.00)
  }
  private weak var delegate: ShoppingCartActionDelegate?
}

// MARK: - View Lifecycle
extension ShoppingCartViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = UIView()
    
    configurePurchaseButton(isCartEmpty: isCartEmpty)
    loadContentCards()
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: nil) { _ in
      UIView.animate(withDuration: 1.0) {
        self.gestureView?.frame.origin.y = self.purchaseButton.frame.origin.y - 200
      }
    }
  }
}

// MARK: - Public Methods
extension ShoppingCartViewController {
  func configure(with items: [Tile], delegate: ShoppingCartActionDelegate? = nil) {
    self.items = items
    self.delegate = delegate
  }
}

// MARK: - Private Methods
extension ShoppingCartViewController {
  func loadContentCards() {
    BrazeManager.shared.addObserverForContentCards(observer: self, selector: #selector(contentCardsUpdated))
    BrazeManager.shared.requestContentCardsRefresh()
  }
  
  @objc func contentCardsUpdated(_ notification: Notification) {
    guard let contentCards = BrazeManager.shared.handleContentCardsUpdated(notification, for: [.coupon]) as? [Coupon], !contentCards.isEmpty else { return }
    
    coupon = contentCards.first
    configureGestureView(coupon?.imageUrl)
  }
  
  func configurePurchaseButton(isCartEmpty: Bool) {
    purchaseButton?.isHidden = isCartEmpty
    purchaseButton?.setTitle("PURCHASE FOR " + totalPrice.formattedCurrencyString()!, for: .normal)
  }
  
  /// Configures the interactable view with an image if the user has at least 1 item in the shopping cart. If the `gestureView` is not nil, the method will return immediately.
  /// - parameter imageUrl: URL that will be used to load an image in the view.
  func configureGestureView(_ imageUrl: String?) {
    guard !isCartEmpty, gestureView == nil else { return }
    
    gestureView = .fromNib()
    let origin = CGPoint(x: -gestureView!.frame.size.width, y: purchaseButton.frame.origin.y - 200)
    gestureView?.configureView(imageUrl, origin, 0, .left, self)
    view.addSubview(gestureView!)
    coupon?.logContentCardImpression()
  }
  
  func emptyCart(logEvent: Bool) {
    guard !isCartEmpty else { return }
    items.removeAll()
    
    gestureView?.dismiss()
    delegate?.emptiedCart()
    
    if logEvent {
      BrazeManager.shared.logCustomEvent("Emptied items from cart")
    }
  }
  
  func purchaseItems() {
    guard !isCartEmpty else { return }
    presentAlert(title: "Purchase Successful", message: nil)
    
    logPurchase(with: items)
  }
  
  func logPurchase(with items: [Tile]) {
    for (item, quantity) in items.countDictionary {
      BrazeManager.shared.logPurchase(productIdentifier: item.title, inCurrency: "USD", atPrice: "\(item.price ?? 0.00)", withQuantity: quantity)
    }
  }
}

// MARK: - SwipeViewEventDelgate
extension ShoppingCartViewController: GestureViewEventDelegate {
  func viewDidTap() {
    configurePurchaseButton(isCartEmpty: isCartEmpty)
    gestureView?.dismiss()
    
    let eventTitle = "Coupon Added"
    let action = UIAlertAction(title: "Woo!", style: .default, handler: nil)
    presentAlert(title: eventTitle, message: "Your total price has been updated", actions: [action])
    
    BrazeManager.shared.logCustomEvent(eventTitle)
    coupon?.logContentCardClicked()
  }
}
