import Foundation

enum NetworkRequestError: Error {
  case invalidUrl
  case invalidJson(String)
}

class NetworkRequest<T: Codable>: NSObject {
  static func makeRequest() async throws -> T {
    guard let url = URL(string: "https://run.mocky.io/v3/cca73fc8-2121-4be2-9a80-80aa51419f19") else {
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
