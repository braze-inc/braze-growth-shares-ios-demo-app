import UIKit

extension UICollectionView {
  func dequeueReusablCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T? {
    guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T
      else { return nil }
    
    return cell
  }
}
