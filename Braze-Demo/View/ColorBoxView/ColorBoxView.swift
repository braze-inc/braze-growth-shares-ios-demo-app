import UIKit

protocol ColorBoxActionDelegate: AnyObject {
  func boxDidPress(currentColor: UIColor?, colorPickerDelegate: UIColorPickerViewControllerDelegate)
  func colorDidUpdate(newColor: UIColor, tag: Int)
}

class ColorBoxView: UIView {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var colorButton: UIButton!
  
  @IBAction func boxDidPress(_ sender: UIButton) {
    delegate?.boxDidPress(currentColor: sender.backgroundColor, colorPickerDelegate: self)
  }
  
  weak var delegate: ColorBoxActionDelegate?
  
  func configureView(_ title: String?, color: UIColor = .black, tag: Int, delegate: ColorBoxActionDelegate? = nil) {
    self.delegate = delegate
    self.tag = tag
    
    titleLabel.text = title
    colorButton.backgroundColor = color
  }
  
  func setColor(_ color: UIColor) {
    
  }
}

// MARK: Color Picker Delegate
extension ColorBoxView: UIColorPickerViewControllerDelegate {
  func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
    colorButton.backgroundColor = viewController.selectedColor
    
    delegate?.colorDidUpdate(newColor: viewController.selectedColor, tag: tag)
  }
}
