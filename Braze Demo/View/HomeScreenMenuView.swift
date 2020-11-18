import UIKit

protocol HomeScreenMenuViewActionDelegate: class {
  func menuButtonPressed(atIndex index: Int)
}

class HomeScreenMenuView: UIView {
  
  // MARK: - Outlets
  @IBOutlet weak var tileButton: UIButton!
  @IBOutlet weak var groupedButton: UIButton!
  
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
    guard let index = RemoteStorage().retrieve(forKey: .homeScreenType) as? Int else {
      return tileSelectedButtonState()
    }
    
    switch HomeScreenType(rawValue: index) {
    case .tile:
      tileSelectedButtonState()
    case .group:
      groupedSelectedButtonState()
    default:
      tileSelectedButtonState()
    }
  }
  
  func tileSelectedButtonState() {
    tileButton?.backgroundColor = .systemGray4
    groupedButton?.backgroundColor = .white
  }
  
  func groupedSelectedButtonState() {
    tileButton?.backgroundColor = .white
    groupedButton?.backgroundColor = .systemGray4
  }
}
