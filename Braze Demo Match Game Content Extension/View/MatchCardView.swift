import UIKit

@objc protocol MatchCardViewDelegate: class {
  func cardTapped(at index: Int)
}

class MatchCardView: UIView {
  
  // MARK: - Outlets
  @IBOutlet private weak var delegate: MatchCardViewDelegate?
  @IBOutlet private weak var button: UIButton!
  
  // MARK: - Actions
  @IBAction func cardTapped(_ sender: UIButton) {
    delegate?.cardTapped(at: sender.tag)
    
    flipCard()
  }
  
  func configureImage(_ selectedImage: UIImage?) {
    button.setImage(selectedImage, for: .selected)
  }
  
  func flipCard() {
    button.isSelected.toggle()
    isUserInteractionEnabled = !button.isSelected
    
    UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
  }
}
