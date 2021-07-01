import UIKit

class ColorConfigurationView: UIView {
  
  // MARK: - Outlets
  @IBOutlet weak var stackView: UIStackView!
  
  func configureView(_ delegate: ColorBoxActionDelegate? = nil) {
    let borderColor: ColorBoxView = .fromNib()
    borderColor.configureView("Border", tag: 0, delegate: delegate)
    stackView.addArrangedSubview(borderColor)
    
    let backgroundColor: ColorBoxView = .fromNib()
    backgroundColor.configureView("Background", color: .white, tag: 1, delegate: delegate)
    stackView.addArrangedSubview(backgroundColor)
    
    let labelColor: ColorBoxView = .fromNib()
    labelColor.configureView("Label", tag: 2, delegate: delegate)
    stackView.addArrangedSubview(labelColor)
    
    let linkColor: ColorBoxView = .fromNib()
    linkColor.configureView("Link", tag: 3, delegate: delegate)
    stackView.addArrangedSubview(linkColor)
  }
}
