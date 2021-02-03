import UIKit

private enum FullListSection {
  case switchView
}

class FullListViewController: FullViewController {
  
  // MARK: - Outlets
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var subtitleTextLabel: UILabel!
  
  // MARK: - Actions
  @IBAction func primaryButtonTapped(_ sender: Any) {
    guard let attributeKey = inAppMessage.extras?["attribute_key"] as? String else { return }
    
    AppboyManager.shared.setCustomAttributeWithKey(attributeKey, andValue: selectedItems)
  }
  
  // MARK: - Variables
  private typealias DataSource = UITableViewDiffableDataSource<FullListSection, String>
  private typealias Snapshot = NSDiffableDataSourceSnapshot<FullListSection, String>
  private var selectedItems = [String]()
  private var iconImageViewFrame: CGRect?
  private var dataSource: DataSource!
  
  override var nibName: String {
    return "FullListViewController"
  }
}

// MARK: - View Lifecycle
extension FullListViewController {
  override func loadView() {
    Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(UINib(nibName: SwitchTableViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: SwitchTableViewCell.cellIdentifier)
    
    if let subtitleText = inAppMessage.extras?["subtitle_text"] as? String {
      subtitleTextLabel.text = subtitleText
    }
    
    configureDataSource()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    if iconImageView?.frame != iconImageViewFrame {
      iconImageViewFrame = iconImageView?.frame
      
      addIconImageViewGradientLayer()
    }
  }
}

// MARK: - Private
private extension FullListViewController {
  func addIconImageViewGradientLayer() {
    let gradientMaskLayer = CAGradientLayer()
    gradientMaskLayer.frame = iconImageView?.frame ?? .zero
    gradientMaskLayer.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
    gradientMaskLayer.locations = [0.90, 1]
    iconImageView?.layer.mask = gradientMaskLayer
  }
  
  func configureDataSource() {
    var snapshot = Snapshot()
    let items = inAppMessage.message.separatedByCommaSpaceValue
    snapshot.appendSections([.switchView])
    snapshot.appendItems(items, toSection: .switchView)
    selectedItems = items
    
    dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.cellIdentifier, for: indexPath) as? SwitchTableViewCell else { return UITableViewCell() }
      
      cell.configureCell(item, isOn: self.selectedItems.contains(item), tag: indexPath.row, delegate: self)
      return cell
    })
    
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}

// MARK: - SwitchView Delegate
extension FullListViewController: SwitchViewDelegate {
  func cellDidSwitch(tag: Int) {
    let snapshot = dataSource.snapshot()
    let items = snapshot.itemIdentifiers(inSection: .switchView)
    let item = items[tag]

    if let index = selectedItems.firstIndex(of: item) {
      selectedItems.remove(at: index)
    } else {
      selectedItems.append(item)
    }
    
    dataSource.apply(snapshot, animatingDifferences: true)
  }
}
