import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
  
  // MARK: - Outlets
  @IBOutlet private var firstRowCardViews: [MatchCardView]!
  @IBOutlet private var secondRowCardViews: [MatchCardView]!
  @IBOutlet private var thirdRowCardViews: [MatchCardView]!
  @IBOutlet private weak var stackView: UIStackView!
  @IBOutlet private weak var playAgainButton: UIButton!
  @IBOutlet private weak var bestScoreLabel: UILabel!
  @IBOutlet private weak var attemptsLabel: UILabel!
  
  // MARK: - Actions
  @IBAction func playAgainPressed(_ sender: UIButton) {
    resetGame()
  }
  
  // MARK: - Variables
  private var matchGame = MatchGame()
  
  private var isLandscape: Bool {
    return traitCollection.verticalSizeClass == .compact
  }
  
  private var cardViews: [MatchCardView] {
    if isLandscape {
      return firstRowCardViews + secondRowCardViews
    } else {
      return firstRowCardViews + secondRowCardViews + thirdRowCardViews
    }
  }
  
  // lock/unlock the board to avoid fast fingers, no more than 2 cards visible at a time
  private var lockBoard = false {
    didSet {
     view.isUserInteractionEnabled = !lockBoard
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureBoard()
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
  
  func cardsDidMatch(_ indicies: [Int], currentScore: Int) {
    updateBoard(currentScore: currentScore) {
      self.fadeOutMatchedCards(at: indicies)
    }
  }
  
  func cardsDidNotMatch(_ indicies: [Int], currentScore: Int) {
    updateBoard(currentScore: currentScore) {
      self.flipUnmatchedCards(at: indicies)
    }
  }
}

// MARK: - Private Methods
private extension NotificationViewController {
  func configureBoard() {
    let cardTypes = isLandscape ? CardType.landscapeCases : CardType.allCases
    
    if isLandscape {
      while stackView.arrangedSubviews.count > 2 {
        stackView.arrangedSubviews.last!.removeFromSuperview()
      }
    }
    
    matchGame.configureGame(cardTypes: cardTypes, delegate: self)
  }
  
  func updateBoard(currentScore: Int, animateBoard: @escaping () -> ()) {
    disableBoard()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      self.updateScore(currentScore: currentScore)
      animateBoard()
      self.enableBoard()
    }
  }
  
  func fadeOutMatchedCards(at indicies: [Int]) {
    indicies.forEach { self.fadeOutMatchedCard(at: $0) }
  }
  
  func fadeOutMatchedCard(at index: Int) {
    UIView.animate(withDuration: 0.25) {
      self.cardViews[index].alpha = 0.0
    } completion: { _ in
      if self.matchGame.noMatchesLeft {
        self.displayCompletedBoard()
      }
    }
  }
  
  func flipUnmatchedCards(at indicies: [Int]) {
    indicies.forEach { self.cardViews[$0].flipCard() }
  }
  
  func disableBoard() {
    lockBoard = true
  }
  
  func enableBoard() {
    lockBoard = false
  }
  
  func displayCompletedBoard() {
    bestScoreLabel.text = String(matchGame.getHighScore())
    playAgainButton.isHidden = false
  }
  
  func updateScore(currentScore: Int) {
    attemptsLabel.text = String(currentScore)
  }
  
  func resetGame() {
    matchGame.playAgain()
    playAgainButton.isHidden = true
    cardViews.forEach {
      $0.flipCard()
      $0.alpha = 1.0
    }
    attemptsLabel.text = "0"
  }
}

// MARK: - MatchView Delegate
extension NotificationViewController: MatchCardViewDelegate {
  func cardTapped(at index: Int) {
    matchGame.cardFlipped(at: index)
  }
}
