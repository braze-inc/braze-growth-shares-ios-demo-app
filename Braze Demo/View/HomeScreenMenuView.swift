import UIKit

protocol HomeScreenMenuViewActionDelegate: class {
  func menuButtonPressed(atIndex index: Int)
}

class HomeScreenMenuView: UIView {
  // MARK: - Variables
  private weak var delegate: HomeScreenMenuViewActionDelegate?
  
  // MARK: - Actions
  @IBAction func buttonPressed(_ sender: Any) {
    guard let button = sender as? UIButton else { return }
    delegate?.menuButtonPressed(atIndex: button.tag)
  }
  
  override var isHidden: Bool {
    willSet {
      configureSelectedButton()
    }
  }
  
  func configureDelegate(_ delegate: HomeScreenMenuViewActionDelegate) {
    self.delegate = delegate
  }
}

// MARK: - Private
private extension HomeScreenMenuView {
  func configureSelectedButton() {
    
  }
}
