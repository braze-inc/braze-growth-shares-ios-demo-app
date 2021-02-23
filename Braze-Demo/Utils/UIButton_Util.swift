import UIKit

extension UIButton {
  static func navigationButton(title: String, target: Any?, selector: Selector) -> UIButton {
    let button = UIButton(type: .custom)
    button.setTitle(title, for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
    button.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
    button.addTarget(target, action: selector, for: .touchUpInside)
    return button
  }
}
