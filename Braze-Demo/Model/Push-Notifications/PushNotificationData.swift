import NotificationCenter

// MARK: - PushNotificationsKey
/// A safer alternative to typing "string" types. Declared as `String` type to query the key name via `rawValue`.
enum PushNotificationKey: String {
  
  static var registerAction: UNNotificationCategory {
    let registerAction = UNNotificationAction(identifier: "REGISTER", title: "Register", options: UNNotificationActionOptions(rawValue: 0))
    let registerCategory = UNNotificationCategory(identifier: "lab_register", actions: [registerAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)
    
    return registerCategory
  }
  
  // MARK: - Silent Push Notifications
  case homeTilePriority = "home_tile_priority"
  case refreshHome = "refresh_home"
  case eventName = "event_name"
  
  // MARK: - Content Extension Notifications
  case completedSessionCount = "completed_session_count"
  case totalSessionCount = "total_session_count"
  case nextSessionName = "next_session_name"
  case nextSessionCompleteDate = "next_session_complete_date"
}

// MARK: - Silent Push Notification Names
extension Notification.Name {
  static let defaultAppExperience = Notification.Name("kDefaultApExperience")
  static let homeScreenContentCard = Notification.Name("kHomeScreenContentCard")
  static let reorderHomeScreen = Notification.Name("kReorderHomeScreen")
}
