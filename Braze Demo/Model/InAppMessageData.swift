import Foundation
import UIKit

protocol InAppMessageClickDelegate where Self: UIViewController {
  func inAppMessageHTMLButtonClicked(clickedURL: URL?, buttonID buttonId: String)
}

enum InAppMessageButtonIdKey: String {
  case iconBlack = "app_icon_black"
  case iconGradient = "app_icon_gradient"
}
