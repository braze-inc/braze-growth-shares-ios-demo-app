import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
  
  @IBOutlet private weak var matchGameView: MatchGameView!
  
  func didReceive(_ notification: UNNotification) {
    // self.label?.text = notification.request.content.body
  }

}
