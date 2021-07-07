import UIKit

protocol FontActionDelegate: AnyObject {
  func fontDidUpdate(style: String)
}

class FontConfigurationView: UIView {
  
  // MARK: - Actions
  @IBAction func fontDidChange(_ sender: UISegmentedControl) {
    let fontStyle = sender.selectedSegmentIndex == 0 ? "" : "Custom"
    
    delegate?.fontDidUpdate(style: fontStyle)
  }
  
  // MARK: - Variables
  weak var delegate: FontActionDelegate?
  
  func configureView(delegate: FontActionDelegate?) {
    self.delegate = delegate
  }
}
