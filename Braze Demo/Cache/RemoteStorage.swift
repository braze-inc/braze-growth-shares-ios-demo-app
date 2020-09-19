import Foundation

enum RemoteStorageKey: String, CaseIterable {
  case homeListPriority = "home_list_priority"
  case messageCenterStyle = "message_center_style"
}

struct RemoteStorage {
  func store(_ value: Any, forKey key: String) {
    defaults.set(value, forKey: key)
  }
  
  func retrieve(forKey key: String) -> Any? {
    return defaults.object(forKey: key)
  }
  
  func removeObject(forKey key: String) {
    defaults.removeObject(forKey: key)
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
