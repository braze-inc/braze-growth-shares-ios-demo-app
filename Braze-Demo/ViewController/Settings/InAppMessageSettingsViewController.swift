import UIKit

class InAppMessageSettingsViewController: UIViewController {
  
  // MARK: - Actions
  @IBAction func triggerPressed(_ sender: UIButton) {
    handleTriggerButtonPressed(with: sender.titleLabel?.text)
  }
}

// MARK: - Private
private extension InAppMessageSettingsViewController {
  func handleTriggerButtonPressed(with title: String?) {
    guard let title = title else { return }
    
    let eventTitle = "\(title) Pressed"
    BrazeManager.shared.logCustomEvent(eventTitle)
    
    UINotificationFeedbackGenerator().notificationOccurred(.success)
  }
}
