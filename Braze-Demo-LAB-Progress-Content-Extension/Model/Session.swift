struct SessionData {
  
  // MARK: - Session
  struct Session {
    private(set) var number: Int
    private(set) var isCompleted: Bool
  }
  
  // MARK: - Variables
  private var sessions: [Session] = []
  
  var totalSessions: Int {
    return sessions.count
  }
  
  init(completedSessions: Int, totalSessions: Int) {
    for index in 0...totalSessions - 1 {
      let session = Session(number: index, isCompleted: index <= (completedSessions - 1))
      sessions.append(session)
    }
  }
}

// MARK: - Public Methods
extension SessionData {
  func getSession(at index: Int) -> Session? {
    guard index < totalSessions else { return nil }
    
    return sessions[index]
  }
}

