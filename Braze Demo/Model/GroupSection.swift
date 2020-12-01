enum GroupSection: Hashable {
  case blank
  case group(GroupType)
  case ad
  
  enum GroupType {
    case primary
    case secondary
    case headline
    case info
  }
}

extension GroupSection: RawRepresentable {
  typealias RawValue = Int
  
  init?(rawValue: RawValue) {
    switch rawValue {
    case 0: self = .blank
    case 1: self = .group(.primary)
    case 2: self = .group(.secondary)
    case 3: self = .group(.headline)
    case 4: self = .group(.info)
    case 5: self = .ad
    default: return nil
    }
  }

  var rawValue: RawValue {
    switch self {
    case .blank:             return 0
    case .group(.primary):   return 1
    case .group(.secondary): return 2
    case .group(.headline):  return 3
    case .group(.info):      return 4
    case .ad:                return 5
    }
  }
}
