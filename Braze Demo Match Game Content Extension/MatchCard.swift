import UIKit

enum CardType: String, CaseIterable {
  case angry
  case heartEyes = "heart-eyes"
  case pensive
  case rainbow
  case stunned
  case tearsOfJoy = "tears-of-joy"
}

struct MatchCard {
  var type: CardType
  
  var selectedImage: UIImage? {
    return UIImage(named: type.rawValue)
  }
}

extension MatchCard: Equatable {
  static func ==(lhs: MatchCard, rhs: MatchCard) -> Bool {
    return lhs.type == rhs.type
  }
}


