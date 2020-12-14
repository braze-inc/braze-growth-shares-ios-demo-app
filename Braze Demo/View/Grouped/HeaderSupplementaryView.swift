import UIKit

class HeaderSupplementaryView: UICollectionReusableView {
  static let reuseIdentifier = "header-supplementary-reuse-identifier"
  
  let label = UILabel()
  let view = UIView()
  let borderView = UIView()
 
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}

// MARK: - Private
private extension HeaderSupplementaryView {
  func configure() {
    view.backgroundColor = .white
    view.layer.cornerRadius = 15
    view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    view.translatesAutoresizingMaskIntoConstraints = false
    addSubview(view)
    
    borderView.backgroundColor = .systemGray6
    borderView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(borderView)

    label.font = UIFont.preferredFont(forTextStyle: .headline)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.adjustsFontForContentSizeCategory = true
    view.addSubview(label)
    
    let inset = CGFloat(10)
      
    NSLayoutConstraint.activate([
      view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
      view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
      view.topAnchor.constraint(equalTo: topAnchor, constant: inset),
      view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
      ])
      
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset * 2),
      label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
      label.topAnchor.constraint(equalTo: view.topAnchor, constant: inset),
      label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset)
      ])
      
    NSLayoutConstraint.activate([
      borderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
      borderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
      borderView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
      borderView.heightAnchor.constraint(equalToConstant: 1)
      ])
  }
}

