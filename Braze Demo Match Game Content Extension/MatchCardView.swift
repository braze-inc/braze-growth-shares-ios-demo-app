import UIKit

@objc protocol MatchCardViewDelegate: class {
  func cardTapped(sender: UIButton)
}

class MatchCardView: UIView {
  
  @IBOutlet private weak var delegate: MatchCardViewDelegate?
  
  @IBAction func cardTapped(_ sender: UIButton) {
    flipCard()
    
    delegate?.cardTapped(sender: sender)
  }
}

private extension MatchCardView {
  func flipCard() {
    UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
  }
}
