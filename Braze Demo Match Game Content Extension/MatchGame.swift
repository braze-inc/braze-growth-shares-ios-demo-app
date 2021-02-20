protocol MatchGameDelegate: class {
  func cardsDidLoad(_ cards: [MatchCard])
  func didCardsMatch(_ didCardsMatch: Bool, indicies: [Int], currentScore: Int)
  func gameOver(highScore: Int)
}

struct MatchGame {
  
  // MARK: - Variables
  private var cards = [MatchCard]()
  private var cardTypes = [CardType]()
  private var flippedIndicies = [Int]() // represents the 2 flipped cards
  private var matchedCardsCount = 0
  private weak var delegate: MatchGameDelegate?
  
  private var scoreTracker = ScoreTracker()
  private var noMatchesLeft: Bool {
    return matchedCardsCount == cards.count
  }
}

// MARK: - Public Methods
extension MatchGame {
  mutating func configureGame(cardTypes: [CardType], delegate: MatchGameDelegate? = nil) {
    self.cardTypes = cardTypes
    self.delegate = delegate
    
    loadCards(from: cardTypes)
  }
  
  mutating func playAgain() {
    cards.removeAll()
    flippedIndicies.removeAll()
    matchedCardsCount = 0
    scoreTracker.reset()
    
    loadCards(from: cardTypes)
  }
  
  mutating func cardFlipped(at index: Int) {
    flippedIndicies.append(index)
    
    if flippedIndicies.count == 2 {
      let didCardsMatch = isMatched()
      
      if didCardsMatch {
        scoreTracker.yesMatch()
        
        matchedCardsCount += 2
      } else {
        scoreTracker.noMatch()
      }
      
      delegate?.didCardsMatch(didCardsMatch, indicies: flippedIndicies, currentScore: scoreTracker.score)
      
      if noMatchesLeft {
        delegate?.gameOver(highScore: scoreTracker.getHighScore())
      }
      
      flippedIndicies.removeAll()
    }
  }
}

// MARK: - Private Methods
private extension MatchGame {
  mutating func loadCards(from cardTypes: [CardType]) {
    for type in cardTypes {
      let card = MatchCard(type: type)
      cards.append(card)
      cards.append(card)
    }
    randomizeCards()
    
    delegate?.cardsDidLoad(cards)
  }
  
  // https://www.dartmouth.edu/~chance/teaching_aids/Mann.pdf
  mutating func randomizeCards() {
    cards.shuffle()
    cards.shuffle()
    cards.shuffle()
    cards.shuffle()
    cards.shuffle()
    cards.shuffle()
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
