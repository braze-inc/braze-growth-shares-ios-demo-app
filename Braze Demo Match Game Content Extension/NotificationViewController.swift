import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
  
  @IBOutlet private var cardViews: [MatchCardView]!
  
  private var matchGame = MatchGame()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    matchGame.configureGame(cardTypes: CardType.allCases)
  }
  
  func didReceive(_ notification: UNNotification) {
    // self.label?.text = notification.request.content.body
  }
}

// MARK: - MatchView Delegate
extension NotificationViewController: MatchCardViewDelegate {
  func cardTapped(sender: UIButton) {
    // check if there's a match
  }
}
