import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController {

  // MARK: - Outlets
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var headerLabel: UILabel!
  @IBOutlet private weak var descriptionLabel: UILabel!
  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var registerView: UIView!
  @IBOutlet private weak var emailTextFieldBorderView: UIView! {
    didSet {
      emailTextFieldBorderView.layer.borderColor = UIColor.lightGray.cgColor
    }
  }
  @IBOutlet private weak var emailTextField: UITextField! {
    didSet {
      let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.italicSystemFont(ofSize: 17)]
      emailTextField.attributedPlaceholder = NSAttributedString(string: "Tap here to enter your email", attributes: attributes)
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
  private let closeIdentifier = "CLOSE"
  private lazy var closeAction: UNNotificationAction = {
    UNNotificationAction(identifier: closeIdentifier, title: closeIdentifier.capitalized, options: .authenticationRequired)
  }()
}

// MARK: - Notification Content Extension Methods
extension NotificationViewController: UNNotificationContentExtension {
  func didReceive(_ notification: UNNotification) {
    let content = notification.request.content
    let userInfo = content.userInfo

    titleLabel.text = userInfo[PushNotificationKey.certificationTitle.rawValue] as? String
    descriptionLabel.attributedText = descriptionAttributedText(with: userInfo[PushNotificationKey.certificationDescription.rawValue] as? String)
    imageView.image = imageFromNotification(content: content)
  }

  func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
    if response.actionIdentifier == registerIdentifier {
      UINotificationFeedbackGenerator().notificationOccurred(.success)
      extensionContext?.notificationActions = []
    
      saveRegisteredForCertificationEvent()
      saveEmailCustomAttribute()
      saveEmailUserAttribute()
      
      displayCloseView()
    } else if response.actionIdentifier == closeIdentifier {
      completion(.dismiss)
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
  
  func displayCloseView() {
    extensionContext?.notificationActions = [closeAction]
    
    headerLabel.text = "Thanks for registering!"
    descriptionLabel.text = "You'll receive a confirmation email shortly."
    registerView.removeFromSuperview()
  }
  
  func descriptionAttributedText(with textString: String?) -> NSAttributedString {
    guard let textString = textString else { return NSAttributedString(string: "") }
    
    let style = NSMutableParagraphStyle()
    style.lineSpacing = 7
    let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: style, .font: UIFont(name: "Sailec-Regular", size: 15.0)!]
    
    return NSAttributedString(string: textString, attributes: attributes)
  }
}

// MARK: - Analytics
private extension NotificationViewController {
  /// Saves a custom event to `userDefaults` with the given suite name that is your `App Group` name.  The value `"Event Name`" is explicity saved.
  ///
  /// There is a conditional unwrap to check if there are saved pending events (in the case of multiple registrations) and appends the event or saves a new array with one event.
  func saveRegisteredForCertificationEvent() {
    let customEventDictionary = Dictionary(eventName: "Registered for Certification")
    let remoteStorage = RemoteStorage(storageType: .suite)
    
    if var pendingEvents = remoteStorage.retrieve(forKey: .pendingCustomEvents) as? [[String: Any]] {
      pendingEvents.append(contentsOf: [customEventDictionary])
      remoteStorage.store(pendingEvents, forKey: .pendingCustomEvents)
    } else {
      remoteStorage.store([customEventDictionary], forKey: .pendingCustomEvents)
    }
  }
  
  /// Saves a custom attribute to `userDefaults` with the given suite name that is your `App Group` name.
  ///
  /// There is a conditional unwrap to check if there are saved pending events (in the case of multiple registrations) and appends the event or saves a new array with one event.
  func saveEmailCustomAttribute() {
    guard let email = registerEmail else { return }
    
    let customAttributeDictionary: [String: Any] = ["Certification Registration Email": email]
    let remoteStorage = RemoteStorage(storageType: .suite)
    
    if var pendingAttributes = remoteStorage.retrieve(forKey: .pendingCustomAttributes) as? [[String: Any]] {
      pendingAttributes.append(contentsOf: [customAttributeDictionary])
      remoteStorage.store(pendingAttributes, forKey: .pendingCustomAttributes)
    } else {
      remoteStorage.store([customAttributeDictionary], forKey: .pendingCustomAttributes)
    }
  }
  
  /// Saves an encoded `userAttribute` object to `userDefaults` with the given suite name that is your `App Group` name.
  ///
  /// There is a conditional unwrap to check if there are saved pending attributes (in the case of other attributes being saved from another notification) and appends the event or saves a new array with one attribute. If there are multiple registrations, the most recent email used will be saved to the user profile. 
  func saveEmailUserAttribute() {
    guard let email = registerEmail,
          let data = try? PropertyListEncoder().encode(UserAttribute.email(email)) else { return }
        
    let remoteStorage = RemoteStorage(storageType: .suite)
    
    if var pendingAttributes = remoteStorage.retrieve(forKey: .pendingUserAttributes) as? [Data] {
      pendingAttributes.append(contentsOf: [data])
      remoteStorage.store(pendingAttributes, forKey: .pendingUserAttributes)
    } else {
      remoteStorage.store([data], forKey: .pendingUserAttributes)
    }
  }
}
