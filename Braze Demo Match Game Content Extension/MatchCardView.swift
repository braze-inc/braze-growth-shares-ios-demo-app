import UIKit

@objc protocol MatchCardViewDelegate: class {
  func cardTapped(sender: UIButton)
}

class MatchCardView: UIView {
  
  @IBOutlet private weak var delegate: MatchCardViewDelegate?
  @IBOutlet private weak var button: UIButton?
  
  @IBAction func cardTapped(_ sender: UIButton) {
    delegate?.cardTapped(sender: sender)
    
    flipCard()
  }
  
  func configureSelectedImage(_ image: UIImage?) {
    button?.setImage(image, for: .selected)
  }
}

private extension MatchCardView {
  func flipCard() {
    button?.isSelected.toggle()
    
    UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
  }
}
