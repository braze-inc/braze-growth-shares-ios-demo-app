extension Dictionary {
  init(eventName: String, properties: [String: AnyHashable]? = nil) {
    self.init()
    self["event_name" as! Key] = eventName as? Value
    
    if let properties = properties {
      for (key, value) in properties {
        self[key as! Key] = value as? Value
      }
    }
  }
}
