import UIKit

protocol ConfigSettingsDelegate: AnyObject {
  func didUpdateConfig(identifier: Int)
}

private enum ConfigSection {
  case list
}

class ConfigSettingsViewController: UIViewController {
  
  // MARK: - Outlets
  @IBOutlet private weak var tableView: UITableView!
  
  // MARK: - Variables
  private typealias DataSource = UITableViewDiffableDataSource<ConfigSection, ConfigData>
  private typealias Snapshot = NSDiffableDataSourceSnapshot<ConfigSection, ConfigData>
  private var dataSource: DataSource!
  private var selectedRow = -1
  private weak var delegate: ConfigSettingsDelegate?
  
  var configs: [ConfigData] = [] {
    didSet {
      configureDataSource()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    Task {
      let metaData = await self.loadConfigData()
      self.configs = metaData?.data ?? []
    }
  }
  
  func configureDelegate(_ delegate: ConfigSettingsDelegate) {
    self.delegate = delegate
  }
  
  private func loadConfigData() async -> ConfigMetaData? {
    do {
      return try await NetworkRequest.makeRequest(string: "https://masquerade.k8s.tools-001.p-use-1.braze.com/api/configs?populate=attributes")
    } catch {
      return nil
    }
  }
  
  private func configureDataSource() {
    var snapshot = Snapshot()
    snapshot.appendSections([.list])
    snapshot.appendItems(configs, toSection: .list)
    
    dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: ConfigTableViewCell.cellIdentifier, for: indexPath) as? ConfigTableViewCell else { return UITableViewCell() }
      
      let isSelected = item.config.detail.id == ConfigManager.shared.identifier
      if isSelected {
        self.selectedRow = indexPath.row
      }
      
      cell.configureCell(title: item.config.detail.configTitle, identifier: item.config.detail.id, updated: item.config.updatedAtReadable, isSelected: isSelected)
      return cell
    })
    
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}

extension ConfigSettingsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    
    let newSelectedRow = indexPath.row
    if selectedRow == newSelectedRow { return }
    
    let config = configs[indexPath.row]
    let identifier = config.config.detail.id
    
    ConfigManager.shared.identifier = identifier
    delegate?.didUpdateConfig(identifier: identifier)
 
    if let previousCell = tableView.cellForRow(at: IndexPath(row: selectedRow, section: indexPath.section)) {
      previousCell.accessoryType = .none
    }

    if let cell = tableView.cellForRow(at: indexPath) {
      cell.accessoryType = .checkmark
    }
    
    selectedRow = indexPath.row
  }
}
