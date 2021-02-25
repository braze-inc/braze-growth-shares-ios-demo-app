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
  
  func configureView(_ sessionString: String?, isSessionCompleted: Bool) {
    sessionNumberLabel.text = sessionString
    sessionNumberLabel.textColor = isSessionCompleted ? .white : .black
    
    backgroundColor = isSessionCompleted ? .systemGreen : UIColor(named: "progress-background-color")
  }
  
  func configureBlankView() {
    backgroundColor = .clear
  }
}
