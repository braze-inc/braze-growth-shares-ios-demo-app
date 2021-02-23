struct APITriggeredCampaignRequest: APIRequest {
  private(set) var method: HTTPMethod = .post
  private(set) var path: String = "/campaigns/trigger/send"
  private(set) var parameters: [String : String]?
  private(set) var body: [String : Any]?
  private(set) var additionalHeaders: [String : String]?
  
  init(campaignId: String, campaignAPIKey: String, userId: String, triggerProperties: [String: Any]) {
    var body = [String: Any]()
    body["campaign_id"] = campaignId
    body["trigger_properties"] = triggerProperties
    body["broadcast"] = false
    body["recipients"] = [["external_user_id": userId]]
    
    self.body = body
    self.additionalHeaders = ["Authorization": "Bearer \(campaignAPIKey)"]
  }
}
