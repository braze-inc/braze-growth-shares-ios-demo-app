import UIKit

extension UIViewController {
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
