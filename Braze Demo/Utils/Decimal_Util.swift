import Foundation

extension Decimal {
  func formattedCurrencyString() -> String? {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter.string(for: self)
  }
}
