// MARK: - InAppMessageKey
/// A safer alternative to typing "string" types. Declared as `String` type to query the key name via `rawValue`.
enum InAppMessageKey: String {
  case viewType = "view_type"
  case attributeKey = "attribute_key"
}

// MARK: - InAppMessageViewType
/// Represents the `view_type` key in your In-App Message key-value pairs.
enum InAppMessageViewType: String {
  case picker
}
