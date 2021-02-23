struct AttemptCounter {
  private(set) var attemptCount = 0
  private var bestScore = Int.max
  
  mutating func increment() {
    attemptCount += 1
  }
  
  mutating func getHighScore() -> Int {
    bestScore = min(bestScore, attemptCount)
    return bestScore
  }
  
  mutating func reset() {
    attemptCount = 0
  }
}
