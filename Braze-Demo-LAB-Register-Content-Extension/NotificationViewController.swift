import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

  // MARK: - Outlets
  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var emailTextField: UITextField! {
    didSet {
      emailTextField.overrideUserInterfaceStyle = .light
    }
  }
  
  // MARK: - Variables
  override var canBecomeFirstResponder: Bool {
    return true
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

  func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
  
    switch response.actionIdentifier {
    case "REGISTER":
      allSet {
        // completion(.dismiss)
      }
    default:
      completion(.doNotDismiss)
    }
  }
}

// MARK: - Email TextField Delegate
extension NotificationViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    textField.resignFirstResponder()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    validateEmail(textField.text)
    return true
  }
}

// MARK: - Private Methods
private extension NotificationViewController {
  func validateEmail(_ email: String?) {
    if let email = email, email.isValidEmail {
      readyToRegister()
    } else {
    }
  }
  
  func readyToRegister() {
    let registerAction = UNNotificationAction(identifier: "REGISTER", title: "Register", options: .authenticationRequired)
    extensionContext?.notificationActions = [registerAction]
  }
  
  func allSet(completion: @escaping () -> ()) {
    completion()
  }
}
