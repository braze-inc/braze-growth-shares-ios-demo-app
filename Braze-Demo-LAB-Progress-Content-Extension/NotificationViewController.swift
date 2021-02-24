import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

  // MARK: - Outlets
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var nextSessionLabel: UILabel!
  @IBOutlet weak var completeNextSessionByLabel: UILabel!
    
  // MARK: - Variables
  private var columnCount: Int {
    return traitCollection.verticalSizeClass == .compact ? 6 : 4
  }
  
  func didReceive(_ notification: UNNotification) {
    configureSessionProgress(with: notification.request.content.userInfo)
    configureNextSessionLabels(with: notification.request.content.userInfo)
  }
}

// MARK: - Private methods
private extension NotificationViewController {
  func configureSessionProgress(with userInfo: [AnyHashable: Any]) {
    guard let sessionsCompletedString = userInfo["session_completed_count"] as? String,
          let totalSessionString = userInfo["session_total_count"] as? String,
          let sessionsCompleted = Int(sessionsCompletedString),
          let totalSessions = Int(totalSessionString)
    else { fatalError("Key-Value Pairs are incorrect.")}
    
    var sessions = 1
    for _ in 0..<2 {
      let sessionStackView = UIStackView()
      sessionStackView.axis = .horizontal
      sessionStackView.distribution = .fillEqually
      sessionStackView.spacing = 10
      
      for _ in 0..<4 {
        let sessionView: SessionView = .fromNib()
        sessionView.configureView(String(sessions), isCompleted: sessions <= sessionsCompleted)
        sessionStackView.addArrangedSubview(sessionView)
        
        sessionView.translatesAutoresizingMaskIntoConstraints = false
        sessionView.widthAnchor.constraint(equalTo: sessionView.heightAnchor, multiplier: 1).isActive = true
        sessions += 1
      }
      
      stackView.addArrangedSubview(sessionStackView)
    }
  }
  
  func configureNextSessionLabels(with userInfo: [AnyHashable: Any]) {
    nextSessionLabel.text = userInfo["next_session_name"] as? String
    completeNextSessionByLabel.text = userInfo["complete_next_session_date"] as? String
  }
}
