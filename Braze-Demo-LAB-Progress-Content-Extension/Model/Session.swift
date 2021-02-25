struct SessionData {
  private(set) var totalSessionCount: Int
  private(set) var completedSessionCount: Int
  
  func getSession(currentSessionCount: Int) -> Session {
    return Session(number: currentSessionCount, isCompleted: currentSessionCount <= completedSessionCount)
  }
  
  struct Session {
    private(set) var number: Int
    private(set) var isCompleted: Bool

    var numberString: String {
      return String(number)
    }
  }
}

