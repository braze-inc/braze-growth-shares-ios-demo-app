import Foundation

enum NetworkRequestError: Error {
  case invalidUrl
  case invalidJson(String)
}

class NetworkRequest<T: Codable>: NSObject {
  static func makeRequest() async throws -> T {
    guard let url = URL(string: "https://run.mocky.io/v3/6a11c26a-9b9e-4811-90b9-e97f98f55d5a") else {
      throw NetworkRequestError.invalidUrl
    }

    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      let result = try JSONDecoder().decode(T.self, from: data)
      return result
    } catch {
      throw NetworkRequestError.invalidJson(error.localizedDescription)
    }
  }
}
