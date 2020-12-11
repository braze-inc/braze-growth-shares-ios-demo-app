import UIKit

private enum SettingsSection {
  case row
}

class AppboySettingsViewController: UIViewController {

  // MARK: - Outlets
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var externalIDTextField: UITextField! {
    didSet {
      guard let userId = AppboyManager.shared.userId, !userId.isEmpty else { return }
      externalIDTextField.text = userId
    }
  }
  
  // MARK: - Actions
  @IBAction func changeUserButtonPressed(_ sender: Any) {
    guard let userId = externalIDTextField.text else { return }
    AppboyManager.shared.changeUser(userId)
    
    presentAlert(title: "Changed User ID to \(userId)", message: nil)
  }
  
  // MARK: - Variables
  private typealias DataSource = UITableViewDiffableDataSource<SettingsSection, String>
  private typealias Snapshot = NSDiffableDataSourceSnapshot<SettingsSection, String>
  private var dataSource: DataSource!
  private let rows = ["Content Cards", "In-App Messages"]
  private let contentCardsSegueIdentifer = "segueToContentCards"
  private let inAppMessagesSegueIdentifier = "segueToInAppMessages"
}

// MARK: - View Lifecycle
extension AppboySettingsViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.tableFooterView = UIView()
    configureDataSource()
  }
}

// MARK: - Private
private extension AppboySettingsViewController {
  func configureDataSource() {
    var snapshot = Snapshot()

    snapshot.appendSections([.row])
    snapshot.appendItems(rows, toSection: .row)
    
    dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
      let cellIdentifier = "RowCell"
     
      var cell: UITableViewCell!
      cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
      if cell == nil {
          cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
      }
      
      cell.textLabel?.text = item
      cell.accessoryType = .disclosureIndicator
      cell.selectionStyle = .none
      
      return cell
    })
    
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}

extension AppboySettingsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    
    switch indexPath.row {
    case 0:
      performSegue(withIdentifier: contentCardsSegueIdentifer, sender: nil)
    case 1:
      performSegue(withIdentifier: inAppMessagesSegueIdentifier, sender: nil)
    default: return
    }
  }
}
