struct ScoreTracker {
  var score = 0
  var highScore = 0
  var matchStreak = 1
  
  mutating func yesMatch() {
    score += (2 * matchStreak)
    matchStreak += 1
  }
  
  mutating func noMatch() {
    score -= 1
    matchStreak = 1
  }
}
