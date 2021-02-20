import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
  
  // MARK: - Outlets
  @IBOutlet private var cardViews: [MatchCardView]!
  @IBOutlet private var cardButtons: [UIButton]!
  @IBOutlet private weak var gameOverLabel: UILabel!
  
  // MARK: - Variables
  private var matchGame = MatchGame()
  var lockBoard = false {
    didSet {
      // freeze/unfreeze the board to avoid fast fingers, no more than 2 cards visible
      view.isUserInteractionEnabled = !lockBoard
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    matchGame.configureGame(cardTypes: CardType.allCases, delegate: self)
  }
  
  func didReceive(_ notification: UNNotification) {
    // self.label?.text = notification.request.content.body
  }
}

// MARK: - MatchGame Delegate
extension NotificationViewController: MatchGameDelegate {
  func didCardsMatch(_ didMatch: Bool, indicies: [Int]) {
    disableBoard()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      didMatch ? self.fadeOutMatchedCards(at: indicies) : self.unflipCards(at: indicies)
      self.enableBoard()
    }
  }
  
  func cardsDidLoad(_ cards: [MatchCard]) {
    guard cards.count == cardButtons.count else { return }
    
    for (card, button) in zip(cards, cardButtons) {
      button.setImage(card.selectedImage, for: .selected)
    }
  }
}

// MARK: - Private Methods
private extension NotificationViewController {
  func fadeOutMatchedCards(at indicies: [Int]) {
    indicies.forEach { self.fadeOutMatchedCard(at: $0) }
  }
  
  func fadeOutMatchedCard(at index: Int) {
    UIView.animate(withDuration: 0.25) {
      self.cardViews[index].alpha = 0.0
    } completion: { _ in
      if self.matchGame.noMatchesLeft {
        self.displayIsGameOverText()
      }
    }
  }
  
  func unflipCards(at indicies: [Int]) {
    indicies.forEach { self.cardViews[$0].flipCard() }
  }
  
  func disableBoard() {
    lockBoard = true
  }
  
  func enableBoard() {
    lockBoard = false
  }
  
  func displayIsGameOverText() {
    gameOverLabel.text = gameOverString()
  }
}

// MARK: - MatchView Delegate
extension NotificationViewController: MatchCardViewDelegate {
  func cardTapped(sender: UIButton) {
    if let cardIndex = cardButtons.firstIndex(of: sender) {
      matchGame.cardFlipped(at: cardIndex)
    }
  }
}

// MARK: - Game Over String
private extension NotificationViewController {
  func gameOverString() -> String {
    return """
      🎉 🎉 🎉 🎉 🎉 🎉 🎉 🎉 🎉

      🎉 🎉 🎉 WINNER!! 🎉 🎉 🎉

      🎉 🎉 🎉 🎉 🎉 🎉 🎉 🎉 🎉
    """
  }
}
