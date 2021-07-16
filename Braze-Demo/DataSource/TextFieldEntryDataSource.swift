import Foundation

struct TextFieldDataSource {
  struct EntryProperty: Hashable {
    let header: String
    let placeholder: String?
    let text: String?
    let buttonTitle: String?
    let entryKey: RemoteStorageKey?
  }
  
  static let entryProperties = [
    EntryProperty(header: "External ID", placeholder: "1234", text: BrazeManager.shared.userId, buttonTitle: "Change User", entryKey: nil),
    EntryProperty(header: "API Key", placeholder: "az34szs3-fdazmfdka-fdakfa-123", text: BrazeManager.shared.apiKeyToUse, buttonTitle: "Change API Key", entryKey: .overrideApiKey),
    EntryProperty(header: "Endpoint", placeholder: "sdk.iad.03.com", text: BrazeManager.shared.endpointToUse, buttonTitle: "Change Endpoint", entryKey: .overrideEndpoint)
    ]
}
