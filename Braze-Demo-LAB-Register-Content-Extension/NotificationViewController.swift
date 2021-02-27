import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

  @IBOutlet private weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
      let content = notification.request.content
      
      if let attachment = content.attachments.first {
        if attachment.url.startAccessingSecurityScopedResource() {
          if let data = try? Data(contentsOf: attachment.url), let image = UIImage(data: data) {
            imageView.image = image
          }
          attachment.url.stopAccessingSecurityScopedResource()
        }
      }
    }

}
