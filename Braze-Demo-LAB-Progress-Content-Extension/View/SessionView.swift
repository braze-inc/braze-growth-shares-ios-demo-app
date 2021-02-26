import UIKit

class SessionView: UIView {
  
  // MARK: - Outlets
  @IBOutlet private var sessionNumberLabel: UILabel!
  
  // MARK: - Variables
  private var isACircle = false
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    guard !isACircle else { return }
    
    layer.cornerRadius = frame.size.width / 2
    isACircle = true
  }
  
  func configureView(_ sessionNumber: Int, isSessionCompleted: Bool) {
    sessionNumberLabel.text = String(sessionNumber + 1)
    sessionNumberLabel.textColor = isSessionCompleted ? .white : .black
    
    backgroundColor = isSessionCompleted ? .systemGreen : UIColor(named: "progress-background-color")
  }
  
  func configureBlankView() {
    sessionNumberLabel.text = ""
    backgroundColor = .clear
  }
}
