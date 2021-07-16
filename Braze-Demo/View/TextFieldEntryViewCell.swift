import UIKit

class TextFieldEntryViewCell: UITableViewCell {
  static let cellIdentifier = "TextFieldEntryViewCell"
  
  // MARK: - Outlets
  @IBOutlet weak var headerLabel: UILabel!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var changeButton: UIButton!
  
  // MARK: - Actions
  @IBAction func changeButtonPressed(_ sender: UIButton) {
    guard let text = textField.text else { return }
    changeButtonPressed?(text)
  }
  
  // MARK: - Variables
  var changeButtonPressed: ((String) -> ())?
  
  func configureCell(_ header: String?, placeholder: String? = nil, text: String?, buttonTitle: String?) {
    headerLabel.text = header
    textField.placeholder = placeholder
    textField.text = text
    changeButton.setTitle(buttonTitle, for: .normal)
  }
}
