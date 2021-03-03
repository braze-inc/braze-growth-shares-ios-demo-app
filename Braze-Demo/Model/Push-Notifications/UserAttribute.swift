/// Saved user attributes are tied to a specific field (firstName, lastName, email, phoneNumber, etc.) and need to be set accordingly when loaded from `UserDefaults`. Individual fields will be set based on the type and its associated value.
///
/// Conforms to the `Codable` protocol to be able to be saved to `UserDefaults`.
enum UserAttribute: Hashable {
  case email(String)
}

// MARK: - Codable
extension UserAttribute: Codable {
  private enum CodingKeys: String, CodingKey {
    case email
  }
  
  func encode(to encoder: Encoder) throws {
    var values = encoder.container(keyedBy: CodingKeys.self)
    
    switch self {
    case .email(let email):
      try values.encode(email, forKey: .email)
    }
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    
    let email = try values.decode(String.self, forKey: .email)
    self = .email(email)
  }
}
