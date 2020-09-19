import Foundation

class LocalDataCoordinator: NSObject {
    func loadData<T: Decodable>(fileName: String, withExtension: String) -> APIResult<T> {
        guard let file = Bundle.main.url(forResource: fileName, withExtension: withExtension) else { return .failure("File Not Found") }
        
        do {
            let jsonData = try Data(contentsOf: file)
            let result = try JSONDecoder().decode(T.self, from: jsonData)
            return .success(result)
        } catch {
            return .failure("Error")
        }
    }
}
