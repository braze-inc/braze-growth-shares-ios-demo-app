import Foundation

extension String {
  var boolValue: Bool? {
    switch lowercased() {
    case "true", "t", "yes", "y", "1":
      return true
    case "false", "f", "no", "n", "0":
      return false
    default:
      return nil
    }
  }
  
  var separatedByCommaSpaceValue: [String] {
    return components(separatedBy: ", ")
  }
  
  var formattedTags: Set<String> {
    return Set(components(separatedBy: ", "))
  }
}
