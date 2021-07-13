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
  
  func colorValue(alpha: CGFloat = 1.0) -> UIColor? {
    if hasPrefix("#") {
      let start = index(startIndex, offsetBy: 1)
      let hexColor = String(self[start...])

      let scanner = Scanner(string: hexColor)
      var hexNumber: UInt64 = 0

      if scanner.scanHexInt64(&hexNumber) {
        let r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255
        let g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255
        let b = CGFloat(hexNumber & 0x0000FF) / 255

        return UIColor(red: r, green: g, blue: b, alpha: alpha)
      }
    }
    
    return nil
  }
}
