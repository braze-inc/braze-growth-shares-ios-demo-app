import UIKit

class PushNotificationsSettingsViewController: UIViewController {
  
  // MARK: - Actions
  @IBAction func triggerPressed(_ sender: UIButton) {
    handleTriggerButtonPressed(with: sender.titleLabel?.text, tag: sender.tag)
  }
  
  // MARK: Match Game Notification
  private lazy var matchGameNotificationRequest: UNNotificationRequest = {
    let content = UNMutableNotificationContent()
    content.title = "Your Braze LAB session starts soon!"
    content.body = "Swipe down on this notification to play a game while you wait"
    content.categoryIdentifier = "match_game"

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    return UNNotificationRequest.init(identifier: "match_game", content: content, trigger: trigger)
  }()
  
  // MARK: Braze LAB Session Progress Notification
  private lazy var sessionProgressNotificationRequest: UNNotificationRequest = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, yyyy"
    let tenDaysFromNow = Calendar.current.date(byAdding: .day, value: 10, to: Date())
    let tenDaysFromNowString = dateFormatter.string(from: tenDaysFromNow ?? Date())
    
    let userInfo = [PushNotificationKey.completedSessionCount.rawValue: "3",
                    PushNotificationKey.totalSessionCount.rawValue: "8",
                    PushNotificationKey.nextSessionName.rawValue: "Currents: The Basics",
                    PushNotificationKey.nextSessionCompleteDate.rawValue: tenDaysFromNowString]
    
    let content = UNMutableNotificationContent()
    content.title = "Your completed a Braze LAB session!"
    content.body = "Swipe down on this notification to check your progress!"
    content.categoryIdentifier = "lab_progress"
    content.userInfo = userInfo

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    return UNNotificationRequest.init(identifier: "lab_progress", content: content, trigger: trigger)
  }()
  
  // MARK: Braze LAB Register Notification
  private var registerNotificationRequest: UNNotificationRequest {
    let userInfo = [PushNotificationKey.certificationTitle.rawValue: "Braze Marketer Certification",
                    PushNotificationKey.certificationDescription.rawValue: "Certified Braze Marketers drive best-in-class customer marketing strategies that will both support the brand's promotional efforts, as well as shape the complete end-to-end customer journey using Braze."]
    
    let imageUrl = localUrl(forImageNamed: "demo-badge", fileExtension: "png")
    let attachment = try! UNNotificationAttachment(identifier: "demo-badge", url: imageUrl!, options: nil)
    
    let content = UNMutableNotificationContent()
    content.title = "Get Braze Certified!"
    content.body = "Swipe on this notification to register"
    content.categoryIdentifier = "lab_register"
    content.attachments = [attachment]
    content.userInfo = userInfo

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    return UNNotificationRequest.init(identifier: "lab_register", content: content, trigger: trigger)
  }
}

// MARK: - Private
private extension PushNotificationsSettingsViewController {
  func handleTriggerButtonPressed(with title: String?, tag: Int) {
    guard let title = title else { return }
    
    #if targetEnvironment(simulator)
      handleSimulatedPushNotification(tag: tag)
    #else
      handleDevicePushNotification(title: title)
    #endif
  }
  
  func handleSimulatedPushNotification(tag: Int) {
    switch tag {
    case 0:
      UNUserNotificationCenter.current().add(matchGameNotificationRequest)
    case 1:
      UNUserNotificationCenter.current().add(sessionProgressNotificationRequest)
    case 2:
      UNUserNotificationCenter.current().add(registerNotificationRequest)
    default:
      return
    }
  }
  
  func handleDevicePushNotification(title: String) {
    let eventTitle = "\(title) Pressed"
    BrazeManager.shared.logCustomEvent(eventTitle)
    
    presentAlert(title: eventTitle, message: "Check your notifications")
    
    UINotificationFeedbackGenerator().notificationOccurred(.success)
  }
}

// MARK: Service Extension Enablement
private extension PushNotificationsSettingsViewController {
  /// For demo purposes only. Loading an image from the assets catalog to display in a local notification.
  /// - parameter name: The name of the image in the assets catalog.
  /// - parameter fileExtension: The file type of the image.
  /// - Returns: The associated url for the corresponding image.
  func localUrl(forImageNamed name: String, fileExtension: String) -> URL? {
    let fileManager = FileManager.default
    let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    let url = cacheDirectory.appendingPathComponent("\(name).\(fileExtension)")

    guard fileManager.fileExists(atPath: url.path) else {
      guard let image = UIImage(named: name),
            let data = image.pngData()
      else { return nil }

      fileManager.createFile(atPath: url.path, contents: data, attributes: nil)
      return url
    }

    return url
  }
}
