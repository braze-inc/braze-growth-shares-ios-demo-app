import UIKit

class FullListViewController: FullViewController {
  
  // MARK: - Outlets
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var subtitleTextLabel: UILabel!
  
  // MARK: - Actions
  @IBAction func primaryButtonTapped(_ sender: Any) {
    guard let attributeKey = inAppMessage.extras?["attribute_key"] as? String else { return }
    
    AppboyManager.shared.setCustomAttributeWithKey(attributeKey, andArrayValue: selectedItems)
  }
  
  // MARK: - Variables
  private var items = [String]()
  private var selectedItems = [String]()
  private var iconImageViewFrame: CGRect?
  
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
    
    tableView.tableFooterView = UIView()
    tableView.register(UINib(nibName: SwitchTableViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: SwitchTableViewCell.cellIdentifier)
    
    if let subtitleText = inAppMessage.extras?["subtitle_text"] as? String {
      subtitleTextLabel.text = subtitleText
    }
    
    items = inAppMessage.message.separatedByCommaSpaceValue
    selectedItems = items
    tableView.reloadData()
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
}

// MARK: - TableView DataSource
extension FullListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.cellIdentifier, for: indexPath) as? SwitchTableViewCell else { return UITableViewCell() }
    
    let item = items[indexPath.row]
    cell.configureCell(items[indexPath.row], isOn: selectedItems.contains(item), tag: indexPath.row, delegate: self)
    return cell
  }
}

// MARK: - SwitchView Delegate
extension FullListViewController: SwitchViewDelegate {
  func cellDidSwitch(tag: Int) {
    let indexPath = IndexPath(item: tag, section: 0)
    let item = items[indexPath.row]
    
    if let index = selectedItems.firstIndex(of: item) {
      selectedItems.remove(at: index)
    } else {
      selectedItems.append(item)
    }
    
    tableView.reloadRows(at: [indexPath], with: .automatic)
  }
}
