import UIKit

class SessionView: UIView {
  
  // MARK: - Outlets
  @IBOutlet private var sessionNumberLabel: UILabel!
  
  // MARK: - Variables
  private var isACircle = false
  
  override func layoutSubviews() {
    guard !isACircle else { return }
    
    layer.cornerRadius = frame.size.width / 2
    isACircle = true
  }
  
  func configureView(_ sessionString: String?, isCompleted: Bool) {
    sessionNumberLabel.text = sessionString
    sessionNumberLabel.textColor = isCompleted ? .white : .black
    
    backgroundColor = isCompleted ? .systemGreen : .systemGray
  }
  
  func configureBlankView() {
    backgroundColor = .clear
  }
}
