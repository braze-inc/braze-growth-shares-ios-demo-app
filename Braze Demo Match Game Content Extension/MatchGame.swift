struct MatchGame {
  
  private(set) var cards = [MatchCard]()
  
  mutating func configureGame(cardTypes: [CardType]) {
    for type in cardTypes {
      let card = MatchCard(type: type)
      cards.append(card)
      cards.append(card)
    }
    randomizeCards()
  }
}

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
}
