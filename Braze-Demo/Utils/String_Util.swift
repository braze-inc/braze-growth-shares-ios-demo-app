import Foundation
import UIKit

extension String {
  /// For demo purposes only. Don't validate an email this way in a production app.
  var isValidEmail: Bool {
    NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
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
