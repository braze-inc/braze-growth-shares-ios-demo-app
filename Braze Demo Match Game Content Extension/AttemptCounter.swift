struct AttemptCounter {
  var attempCount = 0
  var bestScore = Int.max
  
  mutating func increment() {
    attempCount += 1
  }
  
  mutating func getHighScore() -> Int {
    bestScore = min(bestScore, attempCount)
    return bestScore
  }
  
  mutating func reset() {
    attempCount = 0
  }
}
