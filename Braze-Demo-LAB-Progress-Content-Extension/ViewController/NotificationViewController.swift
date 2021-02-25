import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

  // MARK: - Outlets
  @IBOutlet private weak var stackView: UIStackView!
  @IBOutlet private weak var nextSessionLabel: UILabel!
  @IBOutlet private weak var completeNextSessionByLabel: UILabel!
  
  // MARK: - Variables
  private var sessionData: SessionData! {
    didSet {
      rowCount = (sessionData.totalSessionCount + columnCount - 1) / columnCount
    }
  }
  private var rowCount: Int = 0
  private var columnCount: Int {
    return traitCollection.verticalSizeClass == .compact ? 6 : 4
  }
  
  func didReceive(_ notification: UNNotification) {
    let userInfo = notification.request.content.userInfo
    
    guard let completedSessionsString = userInfo[PushNotificationKey.completedSessionCount.rawValue] as? String,
          let totalSessionString = userInfo[PushNotificationKey.totalSessionCount.rawValue] as? String,
          let completedSessions = Int(completedSessionsString),
          let totalSessions = Int(totalSessionString)
    else { fatalError("Key-Value Pairs are incorrect.")}
    
    self.sessionData = SessionData(totalSessionCount: totalSessions, completedSessionCount: completedSessions)
    
    configureNextSessionLabels(with: userInfo)
    configureTotalSessionProgress(rows: rowCount, columns: columnCount)
  }
}

// MARK: - Private methods
private extension NotificationViewController {
  /// Configures the completed session progress layout and views based on the total number of sessions and the number of completed sessions.
  ///
  /// The `rowCount` is determined by the total number of sessions the user has and the `columnCount` value. If there are 8 total sessions and the `columnCount` is 6, the layout will be two horizontal `UIStackView`s with 6 sessions each in the vertical `UIStackView`.
  ///
  /// If there are not enough sessions to fill the columns in the row, the for loop will create blank views to maintain the UI consistency within the `UIStackView`.
  func configureTotalSessionProgress(rows: Int, columns: Int) {
    var currentSessionCount = 1
    
    for _ in 0..<rows {
      let sessionStackView = UIStackView(axis: .horizontal, distribution: .fillEqually, spacing: 10)
      
      for _ in 0..<columns {
        let sessionView: SessionView = .fromNib()
        let session = sessionData.getSession(for: currentSessionCount)
        
        if currentSessionCount <= sessionData.totalSessionCount {
          sessionView.configureView(session.numberString, isCompleted: session.isCompleted)
        } else {
          sessionView.configureBlankView()
        }
        
        sessionStackView.addArrangedSubview(sessionView)
        sessionView.translatesAutoresizingMaskIntoConstraints = false
        sessionView.widthAnchor.constraint(equalTo: sessionView.heightAnchor, multiplier: 1).isActive = true
        
        currentSessionCount += 1
      }
      
      stackView.addArrangedSubview(sessionStackView)
    }
  }
  
  func configureNextSessionLabels(with userInfo: [AnyHashable: Any]) {
    nextSessionLabel.text = userInfo[PushNotificationKey.nextSessionName.rawValue] as? String
    completeNextSessionByLabel.text = userInfo[PushNotificationKey.nextSessionCompleteDate.rawValue] as? String
  }
}
