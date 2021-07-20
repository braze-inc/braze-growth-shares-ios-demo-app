import UIKit

extension UITableView {
  func dequeueResusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T? {
    guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T
    else { return nil }
    
    return cell
  }
}
