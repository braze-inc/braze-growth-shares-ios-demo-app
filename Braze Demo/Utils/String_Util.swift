import Foundation
import UIKit

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
  
  func firstWordBold() -> NSAttributedString {
    let space = " "
    var words = self.components(separatedBy: space)
    let firstWord = words.removeFirst()
    
    let boldAttr: [NSAttributedString.Key: Any] = [.font : UIFont.boldSystemFont(ofSize: 17)]
    let attributedString = NSMutableAttributedString(string: firstWord, attributes: boldAttr)
    let normalString = NSMutableAttributedString(string: space + words.joined(separator: space))
    attributedString.append(normalString)
    
    return attributedString
  }
}
