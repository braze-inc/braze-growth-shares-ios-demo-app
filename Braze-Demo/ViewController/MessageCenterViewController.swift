import UIKit

class MessageCenterViewController: UIViewController {
  
  // MARK: - Outlets
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private var dataSource: MessageCenterDataSource!
  
  // MARK: - Actions
  @IBAction func exitButtonTapped(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  // MARK: - Variables
  private let segueIdentifier = "segueToMessageCenterDetail"
}

// MARK: - View lifecycle
extension MessageCenterViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadContentCards()
    
    tableView.tableFooterView = UIView()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case segueIdentifier:
      guard let detailVc = segue.destination as? MessageCenterDetailViewController,
        // casting to AnyObject: see https://bugs.swift.org/browse/SR-3871
        let message = sender as AnyObject as? Message else { return }
      detailVc.configure(with: message, delegate: self)
    default:
      break
    }
  }
}

// MARK: - Private Methods
private extension MessageCenterViewController {
  func loadContentCards() {
    BrazeManager.shared.addObserverForContentCards(observer: self, selector: #selector(contentCardsUpdated))
    BrazeManager.shared.requestContentCardsRefresh()
  }
  
  @objc func contentCardsUpdated(_ notification: Notification) {
    let contentCards = BrazeManager.shared.handleContentCardsUpdated(notification, for: [.message(.fullPage), .message(.webView)]) as! [Message]
    
    setDataSource(with: contentCards)
  }
  
  func setDataSource(with messages: [Message]) {
    dataSource.configure(with: messages, delegate: self)
    tableView.reloadData()
  }
  
  func updateDataSource(with messageToDelete: Message) {
    dataSource.deleteMessage(messageToDelete)
    tableView.reloadData()
  }
}

// MARK: - CellActionDelegate
extension MessageCenterViewController: CellActionDelegate {
  func cellTapped(with item: Any?) {
    guard let message = item as? Message else { return }
    message.logContentCardClicked()
    
    performSegue(withIdentifier: segueIdentifier, sender: message)
  }
}

// MARK: - MessageActionDelegate
extension MessageCenterViewController: MessageActionDelegate {
  func messageDeleted(_ message: Message) {
    updateDataSource(with: message)
  }
}
