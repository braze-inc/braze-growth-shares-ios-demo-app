import Foundation

extension Array where Element: Hashable {
  var countDictionary: [Element: Int] {
    var dict = [Element: Int]()
    forEach { dict[$0, default: 0] += 1 }
    return dict
  }
}
