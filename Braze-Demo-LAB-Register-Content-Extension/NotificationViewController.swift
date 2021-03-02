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
  private var registerEmail: String? = nil {
    didSet {
      if registerEmail == nil {
        extensionContext?.notificationActions = []
      } else {
        extensionContext?.notificationActions = [registerAction]
      }
    }
  }
  private let registerIdentifier = "REGISTER"
  private lazy var registerAction: UNNotificationAction = {
    UNNotificationAction(identifier: registerIdentifier, title: registerIdentifier.capitalized, options: .authenticationRequired)
  }()
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
        
      extensionContext?.notificationActions = []
      saveRegisteredForCertificationEvent()
      saveEmailAttribute()
      
      displayAllSetView { completion(.dismiss) }
    } else {
      completion(.doNotDismiss)
    }
  }
}

// MARK: - Email TextField Delegate
extension NotificationViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    setRegisterEmail(textField.text)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return textField.resignFirstResponder()
  }
}

// MARK: - Private Methods
private extension NotificationViewController {
  /// Loading an image from a push notifcation.
  ///
  /// The `Service Extension` target must be included with the `ContentExtension` target
  func imageFromNotification(content: UNNotificationContent) -> UIImage? {
    guard let attachment = content.attachments.first else { return nil }
    guard attachment.url.startAccessingSecurityScopedResource() else { return nil }
    let data = try? Data(contentsOf: attachment.url)
    attachment.url.stopAccessingSecurityScopedResource()
    
    return data != nil ? UIImage(data: data!) : nil
  }
  
  func setRegisterEmail(_ email: String?) {
    if let email = email, email.isValidEmail {
      registerEmail = email
    } else {
      registerEmail = nil
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

// MARK: - Analytics
private extension NotificationViewController {
  /// Saves a custom event to `userDefaults` with the given suite name that is your `App Group` name.  The value `"Event Name`" is explicity saved.
  ///
  /// There is a conditional unwrap to check if there are saved pending events (in the case of multiple registrations) and appends the event or saves a new array with one event.
  func saveRegisteredForCertificationEvent() {
    let customEventDictionary = Dictionary<String, Any>(eventName: "Registered for Certification")
    let remoteStorage = RemoteStorage(storageType: .suite)
    
    if var pendingEvents = remoteStorage.retrieve(forKey: .pendingEvents) as? [[String: Any]] {
      pendingEvents.append(contentsOf: [customEventDictionary])
      remoteStorage.store(pendingEvents, forKey: .pendingEvents)
    } else {
      remoteStorage.store([customEventDictionary], forKey: .pendingEvents)
    }
  }
  
  /// Saves a custom attribute to `userDefaults` with the given suite name that is your `App Group` name.
  ///
  /// Saving the value as an array to handle the case of multiple emails being registered from the same user. Braze removes duplicates from custom arribute arrays so there will only be unique values.
  func saveEmailAttribute() {
    guard let email = registerEmail else { return }
    
    let customAttributeDictionary: [String: Any] = ["Certification Registration Email": email]
    let remoteStorage = RemoteStorage(storageType: .suite)
    
    if var pendingAttributes = remoteStorage.retrieve(forKey: .pendingAttributes) as? [[String: Any]] {
      pendingAttributes.append(contentsOf: [customAttributeDictionary])
      remoteStorage.store(pendingAttributes, forKey: .pendingAttributes)
    } else {
      remoteStorage.store([customAttributeDictionary], forKey: .pendingAttributes)
    }
  }
}
