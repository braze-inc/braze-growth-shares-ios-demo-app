import Foundation

enum LocalDataError: Error {
  case error(String)
  case fileNotFound
  case badJSON(String)
}

class LocalDataCoordinator: NSObject {
  func loadData<T: Decodable>(fileName: String, withExtension: String) throws -> T {
    guard let file = Bundle.main.url(forResource: fileName, withExtension: withExtension) else { throw LocalDataError.fileNotFound}
    
    do {
      let jsonData = try Data(contentsOf: file)
      let result = try JSONDecoder().decode(T.self, from: jsonData)
      return result
    } catch {
      throw LocalDataError.badJSON(error.localizedDescription)
    }
  }
}
