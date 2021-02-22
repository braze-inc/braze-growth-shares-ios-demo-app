import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
  
  // MARK: - Outlets
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
  private var cardViews = [MatchCardView]()

  
  private var boardLayout: (rows: Int, columns: Int) {
    if traitCollection.verticalSizeClass == .compact {
      return (2, 4)
    } else {
      return (3, 4)
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
    
    configureBoard(rows: boardLayout.rows, columns: boardLayout.columns)
    matchGame.configureGame(numberOfCards: cardViews.count, delegate: self)
  }
  
  func didReceive(_ notification: UNNotification) {
    // do nothing
  }
}

// MARK: - MatchGame Delegate
extension NotificationViewController: MatchGameDelegate {
  func cardsDidLoad(_ cards: [MatchCard]) {
    configureCardViews(cards)
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
  func configureBoard(rows: Int, columns: Int) {
    for _ in 0..<rows {
      let matchCardsStackView = UIStackView()
      matchCardsStackView.axis = .horizontal
      matchCardsStackView.distribution = .equalSpacing
      matchCardsStackView.spacing = 10

      for _ in 0..<columns {
        let cardView: MatchCardView = .fromNib()
        
        matchCardsStackView.addArrangedSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.widthAnchor.constraint(equalTo: cardView.heightAnchor, multiplier: 2.5/3.5).isActive = true
        
        cardViews.append(cardView)
      }
      
      stackView.addArrangedSubview(matchCardsStackView)
    }
  }
  
  func configureCardViews(_ cards: [MatchCard]) {
    guard cards.count == cardViews.count else { fatalError("Mistakes were made") }
    
    var tag = 0
    for (card, cardView) in zip(cards, cardViews) {
      cardView.configureView(selectedImage: card.selectedImage, tag: tag, delegate: self)
      tag += 1
    }
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
    UIView.animate(withDuration: 0.25) {
      indicies.forEach { self.fadeOutMatchedCard(at: $0) }
    } completion: { _ in
      if self.matchGame.noMatchesLeft {
        self.displayCompletedBoard()
      }
    }
  }
  
  func fadeOutMatchedCard(at index: Int) {
    self.cardViews[index].alpha = 0.0
  }
  
  func flipUnmatchedCards(at indicies: [Int]) {
    indicies.forEach { cardViews[$0].flipCard() }
  }
  
  func disableBoard() {
    lockBoard = true
  }
  
  func enableBoard() {
    lockBoard = false
  }
  
  func updateScore(currentScore: Int) {
    attemptsLabel.text = String(currentScore)
  }
  
  func displayCompletedBoard() {
    let highScore = matchGame.getHighScore()
    
    bestScoreLabel.text = String(highScore)
    playAgainButton.isHidden = false
    
    saveCompletedMatchGameEvent(with: highScore)
  }
  
  func saveCompletedMatchGameEvent(with highScore: Int) {
    let customEventDictionary = [["Event Name": "Completed Match Game", "Score": highScore]] as [[String : Any]]
    let remoteStorage = RemoteStorage(storageType: .suite)
    
    if var pendingEvents = remoteStorage.retrieve(forKey: .pendingEvents) as? [[String: Any]] {
      pendingEvents.append(contentsOf: customEventDictionary)
      remoteStorage.store(pendingEvents, forKey: .pendingEvents)
    } else {
      remoteStorage.store(customEventDictionary, forKey: .pendingEvents)
    }
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
