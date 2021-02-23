import UIKit

protocol MatchCardViewDelegate: class {
  func cardTapped(at index: Int)
}

class MatchCardView: UIView {
  
  // MARK: - Outlets
  @IBOutlet private weak var button: UIButton!
  
  // MARK: - Actions
  @IBAction func cardTapped(_ sender: UIButton) {
    delegate?.cardTapped(at: sender.tag)
    
    flipCard()
  }
  
  // MARK: - Variables
  private weak var delegate: MatchCardViewDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    layer.cornerRadius = 5
    layer.masksToBounds = true
  }
  
  func configureView(selectedImage: UIImage?, tag: Int, delegate: MatchCardViewDelegate? = nil) {
    self.delegate = delegate
    
    button.setImage(selectedImage, for: .selected)
    button.tag = tag
  }
  
  func flipCard() {
    button.isSelected.toggle()
    isUserInteractionEnabled = !button.isSelected
    
    UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
  }
}
