import UIKit

private enum ConfigSection {
  case list
}

class ConfigSettingsViewController: UIViewController {
  
  // MARK: - Outlets
  @IBOutlet private weak var tableView: UITableView!
  
  // MARK: - Variables
  private typealias DataSource = UITableViewDiffableDataSource<ConfigSection, Datum>
  private typealias Snapshot = NSDiffableDataSourceSnapshot<ConfigSection, Datum>
  private var dataSource: DataSource!
  
  var config: Config? {
    didSet {
      configureDataSource()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    Task {
      self.config = await self.loadConfigData()
    }
  }
  
  private func loadConfigData() async -> Config? {
    do {
      return try await NetworkRequest.makeRequest(string: "https://masquerade.k8s.tools-001.p-use-1.braze.com/api/configs?populate=attributes")
    } catch {
      return nil
    }
  }
  
  private func configureDataSource() {
    guard let configs = config?.data else { return }
    
    var snapshot = Snapshot()
    snapshot.appendSections([.list])
    snapshot.appendItems(configs, toSection: .list)
    
    dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, content) -> UITableViewCell? in
      
      let cellIdentifier = "ConfigCell"
      var cell: UITableViewCell!
      cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
      if cell == nil {
          cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
      }
      cell.textLabel?.text = content.attributes.attributes.configTitle
      cell.detailTextLabel?.numberOfLines = 0
      cell.detailTextLabel?.text =
                                  """
                                  Identifier: \(String(content.attributes.attributes.id))
                                  Last Updated: \(content.attributes.updatedAt)
                                  """
      return cell
      
    })
    
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}

extension ConfigSettingsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let config = config!.data[indexPath.row]
    ConfigManager.shared.identifier = config.attributes.attributes.id
  }
}

class ConfigManager: NSObject {
  static let shared = ConfigManager()
  
  var identifier: Int {
    set {
      RemoteStorage().store(newValue, forKey: .configIdentifier)
    }
    get {
      return RemoteStorage().retrieve(forKey: .configIdentifier) as? Int ?? 1
    }
  }
}


// MARK: - Config
struct Config: Codable {
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable, Hashable {
    let id: Int
    let attributes: DatumAttributes
}

// MARK: - DatumAttributes
struct DatumAttributes: Codable, Hashable {
    let createdAt, updatedAt, publishedAt: String
    let attributes: AttributesAttributes
}

// MARK: - AttributesAttributes
struct AttributesAttributes: Codable, Hashable {
    let id: Int
    let apiKey, configTitle, attributesDescription, vertical: String

    enum CodingKeys: String, CodingKey {
        case id
        case apiKey = "api_key"
        case configTitle = "config_title"
        case attributesDescription = "description"
        case vertical
    }
}
