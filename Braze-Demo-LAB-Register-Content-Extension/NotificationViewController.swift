import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController {

  // MARK: - Outlets
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var descriptionLabel: UILabel!
  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var emailTextField: UITextField! {
    didSet {
      emailTextField.overrideUserInterfaceStyle = .light
    }
  }
  
  // MARK: - Variables
  private let registerIdentifier = "REGISTER"
  private lazy var registerAction: UNNotificationAction = {
    UNNotificationAction(identifier: registerIdentifier, title: registerIdentifier.capitalized, options: .authenticationRequired)
  }()
  
  override var canBecomeFirstResponder: Bool {
    return true
  }
}

// MARK: - Notification Content Extension Methods
extension NotificationViewController: UNNotificationContentExtension {
  func didReceive(_ notification: UNNotification) {
    let content = notification.request.content
    let userInfo = content.userInfo

    titleLabel.text = userInfo[PushNotificationKey.certificationTitle.rawValue] as? String
    descriptionLabel.text = userInfo[PushNotificationKey.certificationDescription.rawValue] as? String
    imageView.image = imageFromNotification(content: content)
  }

  func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
    if response.actionIdentifier == registerIdentifier {
      UINotificationFeedbackGenerator().notificationOccurred(.success)
        
      configureNotificationActions([])
      saveRegisteredForCertificationEvent()
      
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
  func imageFromNotification(content: UNNotificationContent) -> UIImage? {
    guard let attachment = content.attachments.first else { return nil }
    guard attachment.url.startAccessingSecurityScopedResource() else { return nil }
    let data = try? Data(contentsOf: attachment.url)
    attachment.url.stopAccessingSecurityScopedResource()
    
    return data != nil ? UIImage(data: data!) : nil
  }
  
  func configureNotificationActions(_ actions: [UNNotificationAction]) {
    extensionContext?.notificationActions = actions
  }
  
  func validateEmail(_ email: String?) {
    if let email = email, email.isValidEmail {
      configureNotificationActions([registerAction])
    } else {
      configureNotificationActions([])
    }
  }
  
  /// Saves a custom event to `userDefaults` with the given suite name that is your `App Group` name.  The value `"Event Name`" is explicity saved.
  ///
  /// There is a conditional unwrap to check if there are saved pending events (in the case of multiple registrations) and appends the event or saves a new array with one event.
  func saveRegisteredForCertificationEvent() {
    let customEventDictionary = [["Event Name": "Registered for Certification"]] as [[String : Any]]
    let remoteStorage = RemoteStorage(storageType: .suite)
    
    if var pendingEvents = remoteStorage.retrieve(forKey: .pendingEvents) as? [[String: Any]] {
      pendingEvents.append(contentsOf: customEventDictionary)
      remoteStorage.store(pendingEvents, forKey: .pendingEvents)
    } else {
      remoteStorage.store(customEventDictionary, forKey: .pendingEvents)
    }
  }
  
  func displayAllSetView(completion: @escaping () -> ()) {
    let allSetView: AllSetView = .fromNib()
    allSetView.frame = view.frame
    allSetView.alpha = 0.0
    view.addSubview(allSetView)
    
    UIView.animate(withDuration: 1.0) {
      allSetView.alpha = 1.0
    } completion: { _ in
      DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
        completion()
      }
    }
  }
}
