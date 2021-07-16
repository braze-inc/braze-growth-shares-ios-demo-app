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
  var parameters: [String: String]? { get }
  var body: [String: Any]? { get }
  var additionalHeaders: [String: String]? { get }
}

extension APIRequest {
  var hostname: String? {
    let restEndpoint = BrazeManager.shared.endpointToUse.replacingOccurrences(of: "sdk", with: "rest", options: .literal, range: nil)
    return restEndpoint
  }
  
  var urlComponents: URLComponents {
    var components = URLComponents()
    components.scheme = "https"
    components.host = hostname
    components.path = path
    if let parameters = parameters {
      components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
    }
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

enum APIResult<T> {
    case success(T)
    case failure(String)
}

struct APIURLRequest {
  static func make<T: Decodable>(request: APIRequest, completion: @escaping (APIResult<T>) -> ()) {
    let components = request.urlComponents
    var urlRequest = URLRequest(url: components.url!)
    urlRequest.httpMethod = request.method.rawValue
    for (key, value) in request.headers {
      urlRequest.setValue(value, forHTTPHeaderField: key)
    }
    
    if let body = request.body {
      let jsonData = try? JSONSerialization.data(withJSONObject: body)
      urlRequest.httpBody = jsonData
    }
  
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
