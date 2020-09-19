import Foundation

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
}

protocol APIRequest {
  var method: HTTPMethod { get }
  var hostname: String? { get }
  var path: String { get }
  var body: [String: Any] { get }
  var additionalHeaders: [String: String]? { get }
}

extension APIRequest {
  var urlComponents: URLComponents {
    var components = URLComponents()
    components.scheme = "https"
    components.host = hostname
    components.path = path
    return components
  }
  
  var headers: [String: String] {
    let headers = ["Content-Type": "application/json", "Accept": "application/json"]
    guard let additionalHeaders = additionalHeaders else { return headers }
    
    return headers.merging(additionalHeaders) { (_, allHeaders) -> String in
      return allHeaders
    }
  }
}

struct APITriggeredCampaignRequest: APIRequest {
  private(set) var method: HTTPMethod = .post
  var hostname: String? {
    guard let appboyPlist = Bundle.main.infoDictionary?["Appboy"] as? [AnyHashable: Any] else { return nil }
    return appboyPlist["Endpoint"] as? String
  }
  private(set) var path: String = "/campaigns/trigger/send"
  private(set) var body: [String : Any]
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

enum APIResult<T> {
    case success(T)
    case failure(String)
}

struct APIURLRequest {
  func make<T: Decodable>(request: APIRequest, completion: @escaping (APIResult<T>) -> ()) {
    let components = request.urlComponents
    var urlRequest = URLRequest(url: components.url!)
    urlRequest.httpMethod = request.method.rawValue
    for (key, value) in request.headers {
      urlRequest.setValue(value, forHTTPHeaderField: key)
    }
    
    let body = request.body
    let jsonData = try? JSONSerialization.data(withJSONObject: body)
    urlRequest.httpBody = jsonData
  
    let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
    guard let data = data, error == nil else {
      return completion(.failure(error?.localizedDescription ?? "Error"))
      }
        
      do {
        let result = try JSONDecoder().decode(T.self, from: data)
        completion(.success(result))
      } catch {
       completion(.failure("Error"))
      }
    }

    task.resume()
  }
}
