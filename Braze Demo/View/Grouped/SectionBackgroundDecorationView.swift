import UIKit

class SectionBackgroundDecorationView: UICollectionReusableView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .systemGroupedBackground
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
