import UIKit

protocol SwitchViewDelegate: class {
  func cellDidSwitch(tag: Int)
}

class SwitchTableViewCell: UITableViewCell {
  static let cellIdentifier = "SwitchTableViewCell"
  
  // MARK: - Outlets
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var switchView: UISwitch!
  
  // MARK: - Actions
  @IBAction func didSwitch(_ sender: UISwitch) {
    delegate?.cellDidSwitch(tag: sender.tag)
  }
  
  // MARK: - Variables
  private weak var delegate: SwitchViewDelegate?
  
  func configureCell(_ title: String?, isOn: Bool, tag: Int, delegate: SwitchViewDelegate?) {
    self.delegate = delegate
    
    titleLabel.text = title
    
    switchView.isOn = isOn
    switchView.tag = tag
  }
}
