import UIKit

class SessionView: UIView {
  
  @IBOutlet private var sessionNumberLabel: UILabel!
  private var isACircle = false
  
  func configureView(_ sessionString: String?, isCompleted: Bool) {
    sessionNumberLabel.text = sessionString
    sessionNumberLabel.textColor = isCompleted ? .white : .black
    
    backgroundColor = isCompleted ? .systemBlue : .systemGray
    
  }
  
  override func layoutSubviews() {
    guard !isACircle else { return }
    
    layer.cornerRadius = frame.size.width / 2
    isACircle = true
  }
}
