import UIKit

class ColorConfigurationView: UIView {
  
  // MARK: - Outlets
  @IBOutlet weak var stackView: UIStackView!
  
  func configureView(viewAttributes: [(header: String, color: UIColor)], delegate: ColorBoxActionDelegate? = nil) {
  
    for (index, viewAttribute) in viewAttributes.enumerated() {
      let colorBoxView: ColorBoxView = .fromNib()
      colorBoxView.configureView(viewAttribute.header, color: viewAttribute.color, tag: index, delegate: delegate)
      stackView.addArrangedSubview(colorBoxView)
    }
  }
}
