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
  private let registerIdentifier = "REGISTER"
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
    if response.actionIdentifier == registerIdentifier {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        extensionContext?.notificationActions = []
       
        displayAllSetView { completion(.dismiss) }
    } else {
      completion(.doNotDismiss)
    }
  }
}

// MARK: - Email TextField Delegate
extension NotificationViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    validateEmail(textField.text)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return textField.resignFirstResponder()
  }
}

// MARK: - Private Methods
private extension NotificationViewController {
  func validateEmail(_ email: String?) {
    if let email = email, email.isValidEmail {
      displayRegisterActionButton()
    }
  }
  
  func displayRegisterActionButton() {
    let registerAction = UNNotificationAction(identifier: registerIdentifier, title: registerIdentifier.capitalized, options: .authenticationRequired)
    extensionContext?.notificationActions = [registerAction]
  }
  
  func displayAllSetView(completion: @escaping () -> ()) {
    let allSetView: AllSetView = .fromNib()
    allSetView.frame = view.frame
    allSetView.alpha = 0.0
    view.addSubview(allSetView)
    
    UIView.animate(withDuration: 1.0) {
      allSetView.alpha = 1.0
    } completion: { _ in
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        completion()
      }
    }
  }
}
