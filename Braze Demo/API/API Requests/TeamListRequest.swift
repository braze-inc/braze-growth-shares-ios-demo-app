struct TeamListRequest: APIRequest {
  private(set) var method: HTTPMethod = .get
  private(set) var path: String = "/mlb/teams.json"
  private(set) var parameters: [String : String]?
  private(set) var body: [String : Any]?
  private(set) var additionalHeaders: [String : String]?
}

extension TeamListRequest {
  var hostname: String? {
    return "erikberg.com"
  }
}

protocol Pickerable {
  var title: String { get }
}

// MARK: - Team
struct Team: Codable {
  private(set) var teamID: String
  private(set) var abbreviation: String
  private(set) var title: String

    enum CodingKeys: String, CodingKey {
        case teamID = "team_id"
        case abbreviation
        case title = "full_name"
    }
}
