import UIKit

protocol ConfigurationViewDelegate: AnyObject {
  func colorPressed(_ currentColor: UIColor?)
}

class ColorConfigurationView: UIView {
  
  // MARK: - Outlets
  @IBOutlet var colorButtons: [UIButton]!
  weak var delegate: ConfigurationViewDelegate?
  
  // MARK: - Actions
  @IBAction func colorButtonPressed(_ sender: UIButton) {
    delegate?.colorPressed(sender.backgroundColor)
  }
  
  func configureView(_ delegate: ConfigurationViewDelegate? = nil) {
    self.delegate = delegate
  }
  
  func setBackgroundColor( _ color: UIColor) {
  }
}
