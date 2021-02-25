import UIKit

extension UIStackView {
  convenience init(axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, spacing: CGFloat) {
    self.init()
    
    self.axis = axis
    self.distribution = distribution
    self.spacing = spacing
  }
}
