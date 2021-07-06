import UIKit

class ColorConfigurationView: UIView {
  
  // MARK: - Outlets
  @IBOutlet weak var stackView: UIStackView!
  
  func configureView(borderColor: UIColor?, backgroundColor: UIColor?, labelColor: UIColor?, linkColor: UIColor?, unreadColor: UIColor?, delegate: ColorBoxActionDelegate? = nil) {
    
    let borderColorView: ColorBoxView = .fromNib()
    borderColorView.configureView("Border", color: borderColor, tag: 0, delegate: delegate)
    stackView.addArrangedSubview(borderColorView)
    
    let backgroundColorView: ColorBoxView = .fromNib()
    backgroundColorView.configureView("Background", color: backgroundColor, tag: 1, delegate: delegate)
    stackView.addArrangedSubview(backgroundColorView)
    
    let labelColorView: ColorBoxView = .fromNib()
    labelColorView.configureView("Label", color: labelColor, tag: 2, delegate: delegate)
    stackView.addArrangedSubview(labelColorView)
    
    let linkColorView: ColorBoxView = .fromNib()
    linkColorView.configureView("Link", color: linkColor, tag: 3, delegate: delegate)
    stackView.addArrangedSubview(linkColorView)
    
    let unreadColorView: ColorBoxView = .fromNib()
    unreadColorView.configureView("Unread", color: unreadColor, tag: 4, delegate: delegate)
    stackView.addArrangedSubview(unreadColorView)
  }
}
