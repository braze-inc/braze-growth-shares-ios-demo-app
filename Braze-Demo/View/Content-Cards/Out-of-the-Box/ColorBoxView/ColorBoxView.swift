import UIKit

protocol ColorBoxActionDelegate: AnyObject {
  func boxDidPress(currentColor: UIColor?, colorPickerDelegate: UIColorPickerViewControllerDelegate)
  func colorDidUpdate(newColor: UIColor, tag: Int)
}

class ColorBoxView: UIView {
  
  // MARK: - Outlets
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var colorButton: UIButton!
  
  // MARK: - Actions
  @IBAction private func boxDidPress(_ sender: UIButton) {
    delegate?.boxDidPress(currentColor: sender.backgroundColor, colorPickerDelegate: self)
  }
  
  // MARK: - Variables
  private weak var delegate: ColorBoxActionDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    titleLabel.adjustsFontSizeToFitWidth = true
  }
  
  func configureView(_ title: String?, color: UIColor?, tag: Int, delegate: ColorBoxActionDelegate? = nil) {
    self.delegate = delegate
    self.tag = tag
    
    titleLabel.text = title
    colorButton.backgroundColor = color
  }
}

// MARK: Color Picker Delegate
extension ColorBoxView: UIColorPickerViewControllerDelegate {
  func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
    colorButton.backgroundColor = viewController.selectedColor
    
    delegate?.colorDidUpdate(newColor: viewController.selectedColor, tag: tag)
  }
}
