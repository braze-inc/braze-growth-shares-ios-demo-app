import Foundation

// MARK: - Config
struct ConfigMetaData: Codable {
  let data: [ConfigData]
}

// MARK: - Datum
struct ConfigData: Codable, Hashable {
  let id: Int
  let config: ConfigAttributes
  
  enum CodingKeys: String, CodingKey {
    case id
    case config = "attributes"
  }
}

// MARK: - DatumAttributes
struct ConfigAttributes: Codable, Hashable {
  let createdAt, updatedAt, publishedAt: String
  let detail: ConfigDetailAttributes
  
  enum CodingKeys: String, CodingKey {
    case createdAt, updatedAt, publishedAt
    case detail = "attributes"
  }
  
  var updatedAtReadable: String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    guard let date = dateFormatter.date(from: updatedAt) else { return nil }
    
    dateFormatter.timeZone = .current
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .medium
    
    return dateFormatter.string(from: date)
  }
}

// MARK: - AttributesAttributes
struct ConfigDetailAttributes: Codable, Hashable {
  let id: Int
  let apiKey, configTitle, attributesDescription, vertical: String?

  enum CodingKeys: String, CodingKey {
    case id
    case apiKey = "api_key"
    case configTitle = "config_title"
    case attributesDescription = "description"
    case vertical
  }
}
