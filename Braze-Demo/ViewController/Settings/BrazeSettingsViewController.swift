import UIKit

private enum SettingsSection {
  case environment
  case config
  case channel
}

class BrazeSettingsViewController: UIViewController {

  // MARK: - Outlets
  @IBOutlet private weak var tableView: UITableView!
  
  // MARK: - Variables
  private typealias DataSource = UITableViewDiffableDataSource<SettingsSection, AnyHashable>
  private typealias Snapshot = NSDiffableDataSourceSnapshot<SettingsSection, AnyHashable>
  private var dataSource: DataSource!
  private let rows = ["Content Cards", "In-App Messages", "Push Notifications"]
  private let configSegueIdentifier = "segueToConfig"
  private let contentCardsSegueIdentifer = "segueToContentCards"
  private let inAppMessagesSegueIdentifier = "segueToInAppMessages"
  private let pushNotificationsSegueIdentifier = "segueToPushNotifications"
}

// MARK: - View Lifecycle
extension BrazeSettingsViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.tableFooterView = UIView()
    configureDataSource()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    switch segue.identifier {
    case configSegueIdentifier:
      guard let viewController = segue.destination as? ConfigSettingsViewController else { break }
      viewController.configureDelegate(self)
    default:
      break
    }
  }
}

extension BrazeSettingsViewController: ConfigSettingsDelegate {
  func didUpdateConfig(identifier: Int) {
    var snapshot = dataSource.snapshot()
    snapshot.reloadItems([ConfigManager.shared])
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}

// MARK: - Private
private extension BrazeSettingsViewController {
  func configureDataSource() {
    var snapshot = Snapshot()

    snapshot.appendSections([.environment, .config, .channel])
    snapshot.appendItems(TextFieldDataSource.entryProperties, toSection: .environment)
    snapshot.appendItems([ConfigManager.shared], toSection: .config)
    snapshot.appendItems(rows, toSection: .channel)
    
    dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, content) -> UITableViewCell? in
      
      switch content {
      case let item as String:
        return self.defaultTableViewCell(cellIdentifier: "RowCell", textLabelText: item)
      case let item as ConfigManager:
        return self.defaultTableViewCell(cellIdentifier: "ConfigCell", textLabelText: "Identifier: \(item.identifier)")
      case let textEntry as TextFieldDataSource.EntryProperty:
        let cell: TextFieldEntryViewCell! = tableView.dequeueResusableCell(for: indexPath)
        cell.configureCell(textEntry.header, placeholder: textEntry.placeholder, text: textEntry.text, buttonTitle: textEntry.buttonTitle)
  
        cell.changeButtonPressed = { [weak self] text in
          guard let self = self else { return }
          self.performCellAction(textEntry: textEntry, text: text, indexPath: indexPath)
        }

        cell.separatorInset = .zero
        return cell
      default:
        return UITableViewCell()
      }
    })
    
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}

extension BrazeSettingsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let label = UILabel()
    label.backgroundColor = .white
    
    switch section {
    case 0: label.text = "ENVIRONMENT SETTINGS"
    case 1: label.text = "CONFIG SETTINGS"
    case 2: label.text = "CHANNEL SETTINGS"
    default: break
    }
    
    label.font = UIFont.preferredFont(forTextStyle: .headline)
    label.textAlignment = .center
    return label
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 60
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    
    switch (indexPath.section, indexPath.row) {
    case (1,0):
      performSegue(withIdentifier: configSegueIdentifier, sender: nil)
    case (2,0):
      performSegue(withIdentifier: contentCardsSegueIdentifer, sender: nil)
    case (2,1):
      performSegue(withIdentifier: inAppMessagesSegueIdentifier, sender: nil)
    case (2,2):
      performSegue(withIdentifier: pushNotificationsSegueIdentifier, sender: nil)
    default: return
    }
  }
}

// MARK: - Private
private extension BrazeSettingsViewController {
  func defaultTableViewCell(cellIdentifier: String, textLabelText: String) -> UITableViewCell {
    var cell: UITableViewCell!
    cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
    if cell == nil {
        cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
    }
    cell.textLabel?.text = textLabelText
    cell.accessoryType = .disclosureIndicator
    cell.selectionStyle = .none
    return cell
  }
  
  func performCellAction(textEntry: TextFieldDataSource.EntryProperty, text: String, indexPath: IndexPath) {
    var alertTitle = ""
    var alertMessage = ""
    
    switch indexPath.row {
    case 0:
      if text.isEmpty {
        alertTitle = "Value cannot be empty"
      } else {
        alertTitle = "Changed to \(text)"
        BrazeManager.shared.changeUser(text)
      }
    default:
      if let key = textEntry.entryKey {
        if text.isEmpty {
          alertTitle = "Reset to default value"
          RemoteStorage().removeObject(forKey: key)
          
        } else {
          alertTitle = "Changed to \(text)"
          alertMessage = "Force close and relaunch app"
          RemoteStorage().store(text, forKey: key)
        }
      }
    }
    
    self.presentAlert(title: alertTitle, message: alertMessage)
  }
}
