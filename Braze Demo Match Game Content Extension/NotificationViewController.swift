import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
  
  // MARK: - Outlets
  @IBOutlet private var cardViews: [MatchCardView]!
  @IBOutlet weak var playAgainButton: UIButton!

  // MARK: - Actions
  @IBAction func playAgainPressed(_ sender: UIButton) {
    matchGame.playAgain()
    playAgainButton.isHidden = true
    cardViews.forEach {
      $0.flipCard()
      $0.alpha = 1.0
    }
  }
  
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
  func cardsDidLoad(_ cards: [MatchCard]) {
    guard cards.count == cardViews.count else { return }
    
    for (card, cardView) in zip(cards, cardViews) {
      cardView.configureImage(card.selectedImage)
    }
  }
  
  func didCardsMatch(_ didCardsMatch: Bool, indicies: [Int]) {
    disableBoard()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      didCardsMatch ? self.fadeOutMatchedCards(at: indicies) : self.unflipCards(at: indicies)
      self.enableBoard()
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
        self.displayPlayAgainText()
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
  
  func displayPlayAgainText() {
    playAgainButton.isHidden = false
  }
}

// MARK: - MatchView Delegate
extension NotificationViewController: MatchCardViewDelegate {
  func cardTapped(at index: Int) {
    matchGame.cardFlipped(at: index)
  }
}
