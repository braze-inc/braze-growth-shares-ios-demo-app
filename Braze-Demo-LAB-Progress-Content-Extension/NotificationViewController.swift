import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

  // MARK: - Outlets
  @IBOutlet private weak var stackView: UIStackView!
  @IBOutlet private weak var nextSessionLabel: UILabel!
  @IBOutlet private weak var completeNextSessionByLabel: UILabel!
  
  // MARK: - Variables
  private var completedSessions: Int = 0
  private var totalSessions: Int = 0 {
    didSet {
      rowCount = totalSessions / columnCount
      
      if totalSessions % columnCount != 0 {
        rowCount += 1
      }
    }
  }
  
  private var rowCount: Int = 0
  private var columnCount: Int {
    return traitCollection.verticalSizeClass == .compact ? 6 : 4
  }
  
  func didReceive(_ notification: UNNotification) {
    let userInfo = notification.request.content.userInfo
    
    guard let completedSessionsString = userInfo["session_completed_count"] as? String,
          let totalSessionString = userInfo["session_total_count"] as? String,
          let completedSessions = Int(completedSessionsString),
          let totalSessions = Int(totalSessionString)
    else { fatalError("Key-Value Pairs are incorrect.")}
    
    self.completedSessions = completedSessions
    self.totalSessions = totalSessions
    
    configureNextSessionLabels(with: userInfo)
    configureTotalSessionProgress()
  }
}

// MARK: - Private methods
private extension NotificationViewController {
  func configureTotalSessionProgress() {
    var sessionCount = 1
    
    for _ in 0..<rowCount {
      let sessionStackView = UIStackView()
      sessionStackView.axis = .horizontal
      sessionStackView.distribution = .fillEqually
      sessionStackView.spacing = 10
      
      for _ in 0..<columnCount {
        let sessionView: SessionView = .fromNib()
        
        if sessionCount <= totalSessions {
          sessionView.configureView(String(sessionCount), isCompleted: sessionCount <= completedSessions)
        } else {
          sessionView.configureBlankView()
        }
        
        sessionStackView.addArrangedSubview(sessionView)
        sessionView.translatesAutoresizingMaskIntoConstraints = false
        sessionView.widthAnchor.constraint(equalTo: sessionView.heightAnchor, multiplier: 1).isActive = true
        
        sessionCount += 1
      }
      
      stackView.addArrangedSubview(sessionStackView)
    }
  }
  
  func configureNextSessionLabels(with userInfo: [AnyHashable: Any]) {
    nextSessionLabel.text = userInfo["next_session_name"] as? String
    completeNextSessionByLabel.text = userInfo["complete_next_session_date"] as? String
  }
}
