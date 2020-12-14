import UIKit

class FooterSupplementaryView: UICollectionReusableView {
  static let reuseIdentifier = "footer-supplementary-reuse-identifier"
    
  let view = UIView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}

private extension FooterSupplementaryView {
  func configure() {
    view.backgroundColor = .white
    view.layer.cornerRadius = 15
    view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    view.translatesAutoresizingMaskIntoConstraints = false
    addSubview(view)
    
    let inset: CGFloat = 10
    NSLayoutConstraint.activate([
      view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
      view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
      view.topAnchor.constraint(equalTo: topAnchor, constant: 0),
      view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
      ])
  }
}
