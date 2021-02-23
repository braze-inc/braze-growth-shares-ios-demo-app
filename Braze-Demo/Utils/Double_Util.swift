import Foundation

extension Double {
  func formattedDateString() -> String {
    let date = Date(timeIntervalSince1970: self)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/YY"
    dateFormatter.locale = .current
    return dateFormatter.string(from: date)
  }
}
