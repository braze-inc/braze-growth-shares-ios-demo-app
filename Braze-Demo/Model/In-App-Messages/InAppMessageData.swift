// MARK: - InAppMessageKey
/// A safer alternative to typing "string" types. Declared as `String` type to query the key name via `rawValue`.
///
///Represents the keys in your in-app message key-value pairs.
enum InAppMessageKey: String {
  case viewType = "view_type"
  case attributeKey = "attribute_key"
}

// MARK: - InAppMessageViewType
/// Represents the `view_type` key in your in-app message key-value pairs.
enum InAppMessageViewType: String {
  case picker
  case tableList = "table_list"
  case permission
}
