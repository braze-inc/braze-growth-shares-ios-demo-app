import UIKit

protocol GestureViewEventDelegate: class {
  func viewDidTap()
}

class ContentCardGestureView: UIView {
  // MARK: - Outlets
  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var swipeGesture: UISwipeGestureRecognizer!
  private weak var delegate: GestureViewEventDelegate?
  
  // MARK: - Actions
  @IBAction func viewDidSwipe(_ sender: Any) {
    dismiss()
  }
  @IBAction func viewDidTap(_ sender: Any) {
    self.delegate?.viewDidTap()
  }
}

// MARK: - Public Methods
extension ContentCardGestureView {
  func configureView(_ imageUrl: String?) {
    if let urlString = imageUrl, let url = URL(string: urlString) {
      ImageCache.sharedCache.image(from: url) { image in
        if let image = image {
          self.imageView.image = image
        }
      }
    }
  }
  
  func configureView(_ imageUrl: String?, _ origin: CGPoint, _ animatePoint: CGFloat, _ direction: UISwipeGestureRecognizer.Direction, _ delegate: GestureViewEventDelegate? = nil) {
    swipeGesture.direction = direction
    frame.origin = origin
    self.delegate = delegate
    
    configureView(imageUrl)
    
    UIView.animate(withDuration: 1.0, animations: {
      self.frame.origin.x = animatePoint
    })
  }
  
  func dismiss() {
    UIView.animate(withDuration: 0.5, animations: {
      self.frame.origin.x = -self.frame.size.width
    })
  }
}

// MARK: - UIGestureRecognizerDelegate
extension ContentCardGestureView: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}

