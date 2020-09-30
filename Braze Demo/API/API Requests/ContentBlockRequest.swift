struct ContentBlockRequest: APIRequest {
  private(set) var method: HTTPMethod = .get
  private(set) var path: String = "/content_blocks/info"
  private(set) var parameters: [String : String]?
  private(set) var body: [String : Any]?
  private(set) var additionalHeaders: [String : String]?
  
  init(contentBlockAPIKey: String, parameters: [String: String]?) {
    self.parameters = parameters
    self.additionalHeaders = ["Authorization": "Bearer \(contentBlockAPIKey)"]
  }
}

// MARK: - Content Block
struct ContentBlock: Codable {
  let content: String?
}
