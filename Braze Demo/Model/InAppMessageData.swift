// MARK: - InAppMessageViewType
/// A safer alternative to typing "string" types. Declared as `String` type to query the key name via `rawValue`.
///
///Represents the `view_type` key in your In-App Message key-value pairs.
enum InAppMessageViewType: String {
  case picker
}
