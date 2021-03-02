// MARK: - Notification Content Extension Custom Event Dictionary Initializer
extension Dictionary where Key == String, Value == Any {
  /// Initializes a dictionary to be saved/retrieved to/from `UserDefaults` with a required `"event_name"` key.
  /// - parameter eventName: Name of the custom event.
  /// - parameter properties:An NSDictionary of properties to associate with this purchase. Property keys are non-empty NSString objects with <= 255 characters and no leading dollar signs. Property values can be NSNumber booleans, integers, floats < 62 bits, NSDate objects or NSString objects with <= 255 characters.
  init(eventName: String, properties: [String: Any]? = nil) {
    self.init()
    self[PushNotificationKey.eventName.rawValue] = eventName
    
    if let properties = properties {
      for (key, value) in properties {
        self[key] = value
      }
    }
  }
}
