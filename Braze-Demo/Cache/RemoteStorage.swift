import Foundation

enum RemoteStorageKey: String, CaseIterable {
  // MARK: - Home Screen
  case homeTilePriority = "home_tile_priority"
  case homeScreenType = "home_screen_type"
  
  // MARK: - Message Center
  case messageCenterStyle = "message_center_style"
  
  // MARK: - Notification Content Extension Analytics
  case pendingCustomEvents = "pending_custom_events"
  case pendingCustomAttributes = "pending_custom_attributes"
  case pendingUserAttributes = "pending_user_attributes"
  
}

enum RemoteStorageType {
  case standard
  case suite
}

struct RemoteStorage {
  private var storageType: RemoteStorageType = .standard
  
  init(storageType: RemoteStorageType = .standard) {
    self.storageType = storageType
  }
  
  func store(_ value: Any, forKey key: RemoteStorageKey) {
    defaults.set(value, forKey: key.rawValue)
  }
  
  func retrieve(forKey key: RemoteStorageKey) -> Any? {
    return defaults.object(forKey: key.rawValue)
  }
  
  func removeObject(forKey key: RemoteStorageKey) {
    defaults.removeObject(forKey: key.rawValue)
  }
  
  func resetStorageKeys() {
    for key in RemoteStorageKey.allCases {
      defaults.removeObject(forKey: key.rawValue)
    }
  }
}

// MARK: Private
private extension RemoteStorage {
  var defaults: UserDefaults {
    switch storageType {
    case .standard:
      return .standard
    case .suite:
      return UserDefaults(suiteName: "group.com.braze.book-demo")!
    }
  }
}
