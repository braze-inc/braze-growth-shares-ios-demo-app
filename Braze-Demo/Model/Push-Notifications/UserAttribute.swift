enum UserAttribute: Hashable {
  case email(String)
}

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
