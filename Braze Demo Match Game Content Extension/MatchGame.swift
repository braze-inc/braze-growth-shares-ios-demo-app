protocol MatchGameDelegate: class {
  func cardsDidLoad(_ cards: [MatchCard])
  func didCardsMatch(_ didCardsMatch: Bool, indicies: [Int])
}

struct MatchGame {
  
  // MARK: - Variables
  private var cards = [MatchCard]()
  private var cardTypes = [CardType]()
  private var flippedIndicies = [Int]() // array represents the 2 flipped cards
  private var matchedIndicies = [Int]() // array represents the matched pairs
  private weak var delegate: MatchGameDelegate?
  
  var noMatchesLeft: Bool {
    return matchedIndicies.count == cards.count
  }
  
  mutating func configureGame(cardTypes: [CardType], delegate: MatchGameDelegate? = nil) {
    self.cardTypes = cardTypes
    self.delegate = delegate
    
    loadCards(from: cardTypes)
  }
  
  mutating func playAgain() {
    cards.removeAll()
    flippedIndicies.removeAll()
    matchedIndicies.removeAll()
    
    loadCards(from: cardTypes)
  }
  
  mutating func cardFlipped(at index: Int) {
    flippedIndicies.append(index)
    
    if flippedIndicies.count == 2 {
      let didCardsMatch = isMatched()
      delegate?.didCardsMatch(didCardsMatch, indicies: flippedIndicies)
      
      if didCardsMatch {
        matchedIndicies.append(contentsOf: flippedIndicies)
      }
      
      flippedIndicies.removeAll()
    }
  }
}

// MARK: - Private Methods
private extension MatchGame {
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
  
  mutating func loadCards(from cardTypes: [CardType]) {
    for type in cardTypes {
      let card = MatchCard(type: type)
      cards.append(card)
      cards.append(card)
    }
    randomizeCards()
    
    delegate?.cardsDidLoad(cards)
  }
  
  func isMatched() -> Bool {
    var cardsToMatch = [MatchCard]()
    for index in flippedIndicies {
      cardsToMatch.append(cards[index])
    }
    
    return cardsToMatch.allSatisfy { $0.type == cardsToMatch.first?.type}
  }
}
