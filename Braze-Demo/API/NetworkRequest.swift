import Foundation

enum NetworkRequestError: Error {
  case invalidUrl
  case invalidJson(String)
}

class NetworkRequest<T: Codable>: NSObject {
  static func makeRequest(string: String) async throws -> T {
    guard let url = URL(string: string) else {
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
