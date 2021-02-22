protocol MatchGameDelegate: class {
  func cardsDidLoad(_ cards: [MatchCard])
  func cardsDidMatch(_ indicies: [Int], currentScore: Int)
  func cardsDidNotMatch(_ indicies: [Int], currentScore: Int)
}

struct MatchGame {
  
  // MARK: - Variables
  private var cards = [MatchCard]()
  private var numberOfCards = 0
  private var matchedCardsCount = 0
  private var flippedIndicies = [Int]() // represents the 2 flipped cards
  private var attemptCounter = AttemptCounter()
  private weak var delegate: MatchGameDelegate?
  
  var noMatchesLeft: Bool {
    return matchedCardsCount == cards.count
  }
}

// MARK: - Public Methods
extension MatchGame {
  mutating func configureGame(numberOfCards: Int, delegate: MatchGameDelegate? = nil) {
    self.numberOfCards = numberOfCards
    self.delegate = delegate
    
    loadCards(numberOfCards: numberOfCards)
  }
  
  mutating func cardFlipped(at index: Int) {
    flippedIndicies.append(index)
    
    if flippedIndicies.count == 2 {
      attemptCounter.increment()
      
      if isMatched() {
        delegate?.cardsDidMatch(flippedIndicies, currentScore: attemptCounter.attempCount)
        matchedCardsCount += 2
      } else {
        delegate?.cardsDidNotMatch(flippedIndicies, currentScore: attemptCounter.attempCount)
      }
      
      flippedIndicies.removeAll()
    }
  }
  
  mutating func getHighScore() -> Int {
    return attemptCounter.getHighScore()
  }
  
  mutating func playAgain() {
    matchedCardsCount = 0
    attemptCounter.reset()
    
    loadCards(numberOfCards: numberOfCards)
  }
}

// MARK: - Private Methods
private extension MatchGame {
  mutating func loadCards(numberOfCards: Int) {
    cards = []
    
    for index in 0..<numberOfCards / 2 {
      let type = CardType.allCases[index % CardType.allCases.count]
      let card = MatchCard(type: type)
      cards.append(card)
      cards.append(card)
    }
    randomizeCards()
    
    delegate?.cardsDidLoad(cards)
  }
  
  mutating func randomizeCards() {
    cards.shuffle()
  }
  
  func isMatched() -> Bool {
    var cardsToMatch = [MatchCard]()
    for index in flippedIndicies {
      cardsToMatch.append(cards[index])
    }
    
    return cardsToMatch.allSatisfy { $0.type == cardsToMatch.first?.type}
  }
}
