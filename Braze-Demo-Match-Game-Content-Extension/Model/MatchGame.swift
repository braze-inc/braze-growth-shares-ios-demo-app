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
  
  /// The top-left card on the board has an index of 0 and increments from left to right. The bottom-right card has an index of n-1, n representing the number of cards.
  mutating func cardFlipped(at index: Int) {
    flippedIndicies.append(index)
    
    if flippedIndicies.count == 2 {
      checkForMatch(with: flippedIndicies)
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
  /// Creates the deck of cards to be synced up with the card views. The loop creates a pair of `MatchCard` objects with the same `CardType` value.
  /// - parameter numberOfCards: The number of cards the game needs to create. Number of pairs is `numberOfCards / 2`.
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
  
  // SOURCE: - https://www.dartmouth.edu/~chance/teaching_aids/Mann.pdf
  mutating func randomizeCards() {
    for _ in 0..<7 {
      cards.shuffle()
    }
  }
  
  mutating func checkForMatch(with flippedIndicies: [Int]) {
    attemptCounter.increment()
    
    if isMatched(flippedIndicies: flippedIndicies) {
      matchedCardsCount += 2
      delegate?.cardsDidMatch(flippedIndicies, currentScore: attemptCounter.attemptCount)
    } else {
      delegate?.cardsDidNotMatch(flippedIndicies, currentScore: attemptCounter.attemptCount)
    }
  }
  
  /// The indicies are used to fetch the `MatchCard` from the `cards` array and adds the card to the `cardsToMatch` array. If all cards in the array have an equal `CardType`, the return value will be `true`.
  /// - parameter flippedIndicies: Rrepresent an array of each index flipped cards on the board.
  func isMatched(flippedIndicies: [Int]) -> Bool {
    var cardsToMatch = [MatchCard]()
    for index in flippedIndicies {
      cardsToMatch.append(cards[index])
    }
    
    return cardsToMatch.allSatisfy { $0.type == cardsToMatch.first?.type}
  }
}
