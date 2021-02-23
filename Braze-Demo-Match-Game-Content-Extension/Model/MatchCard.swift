import UIKit

enum CardType: String, CaseIterable {
  case angry
  case heartEyes = "heart-eyes"
  case tearsOfJoy = "tears-of-joy"
  case rainbow
  case pensive
  case stunned
}

struct MatchCard {
  private(set) var type: CardType
  
  var selectedImage: UIImage? {
    return UIImage(named: type.rawValue)
  }
}

extension MatchCard: Equatable {
  static func ==(lhs: MatchCard, rhs: MatchCard) -> Bool {
    return lhs.type == rhs.type
  }
}
