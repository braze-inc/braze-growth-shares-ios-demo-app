import Foundation

class ConfigManager: NSObject {
  static let shared = ConfigManager()
  
  var identifier: Int {
    set {
      RemoteStorage().store(newValue, forKey: .configIdentifier)
    }
    get {
      return RemoteStorage().retrieve(forKey: .configIdentifier) as? Int ?? 1
    }
  }
}
