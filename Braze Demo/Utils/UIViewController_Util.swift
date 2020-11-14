import UIKit

extension UIViewController {
  class func fromNib() -> Self {
    func fromNib<T: UIViewController>(_ viewType: T.Type) -> T {
      return T.init(nibName: String(describing: T.self), bundle: nil)
    }
    return fromNib(self)
  }
  
  func presentAlert(title: String?, message: String?, actions: [UIAlertAction] = []) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    if actions.isEmpty {
      alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    } else {
      for action in actions {
        alert.addAction(action)
      }
    }
    present(alert, animated: true, completion: nil)
  }
}
