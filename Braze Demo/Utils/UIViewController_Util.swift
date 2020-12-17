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
  
  // SOURCE: - https://gist.github.com/db0company/369bfa43cb84b145dfd8#gistcomment-2640891
  func topMostViewController() -> UIViewController {
    if let presented = presentedViewController {
      return presented.topMostViewController()
    }
          
    if let navigation = self as? UINavigationController {
      return navigation.visibleViewController?.topMostViewController() ?? navigation
    }
          
    if let tab = self as? UITabBarController {
      return tab.selectedViewController?.topMostViewController() ?? tab
    }
        
    return self
  }
}
