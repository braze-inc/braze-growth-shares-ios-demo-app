import UIKit

class MatchGameView: UIView {
  
  var numberOfPairsOfCards: Int {
      return cardButtons.count / 2
  }
  
  @IBOutlet private var cardButtons: [UIButton]!
}

// MARK: MatchCardView Delegate
extension MatchGameView: MatchCardViewDelegate {
  func cardTapped(sender: UIButton) {
    if let cardNumber = cardButtons.firstIndex(of: sender) {
      print("Card Number is: \(cardNumber)")
    }
  }
}
