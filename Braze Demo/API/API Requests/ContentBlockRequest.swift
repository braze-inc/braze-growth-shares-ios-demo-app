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
///Content Blocks allow users to manage reusable, cross-channel content in a single, centralized location. A custom object is used in the demo is for HTML strings larger than 2kb.
struct ContentBlock: Codable {
  let content: String?
}
//For more info: https://www.braze.com/docs/user_guide/engagement_tools/templates_and_media/content_blocks/ and https://www.braze.com/docs/api/endpoints/templates/content_blocks_templates/get_see_email_content_blocks_information/
