import Foundation

enum RemoteStorageKey: String, CaseIterable {
  case homeListPriority = "home_list_priority"
  case messageCenterStyle = "message_center_style"
  case homeScreenType = "home_screen_type"
}

struct RemoteStorage {
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
    defaults.synchronize()
  }
}

// MARK: Private
private extension RemoteStorage {
  var defaults: UserDefaults {
    return .standard
  }
  
  func value(forKey key: String) -> Any? {
    return defaults.value(forKey: key)
  }
}
