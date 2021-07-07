struct APIRequestBuilder {
  
  public static func make(campaignId: String, campaignAPIKey: String, userId: String, _ triggerProperties: [String: Any], completion: @escaping (String) -> ()) {
    let request = APITriggeredCampaignRequest(campaignId: campaignId, campaignAPIKey: campaignAPIKey, userId: userId, triggerProperties: triggerProperties)
    
    APIURLRequest.make(request: request) { (result: APIResult<[String:String]>) in
      switch result {
      case .success(let response):
        completion(response.description)
      case .failure(let error):
        completion(error)
      }
    }
  }
}
