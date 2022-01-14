import UIKit

class ConfigTableViewCell: UITableViewCell {
  static let cellIdentifier = "ConfigTableViewCell"
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var identifierLabel: UILabel!
  @IBOutlet weak var updatedLabel: UILabel!
  
  func configureCell(title: String?, identifier: Int, updated: String?, isSelected: Bool) {
    titleLabel.text = title
    identifierLabel.text = "Identifier: \(String(identifier))"
    updatedLabel.text = "Updated at: \(updated ?? "")"
    
    accessoryType = isSelected ? .checkmark : .none
  }
}
