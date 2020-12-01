import UIKit
import Appboy_iOS_SDK

class MessageCenterContainerViewController: UIViewController {
  
  // MARK: - IBOutlets
  @IBOutlet private weak var segmentedControl: UISegmentedControl!
  @IBOutlet private weak var segmentedControlHeight: NSLayoutConstraint!
  @IBOutlet private weak var customContainerView: UIView!
  
  // MARK: - IBActions
  @IBAction func segmentChanged(_ sender: Any) {
    guard let segmentedControl = sender as? UISegmentedControl else { return }
    
    customContainerView.isHidden = segmentedControl.selectedSegmentIndex == 1
    defaultContainerView.isHidden = segmentedControl.selectedSegmentIndex == 0
  }
  // MARK: - Variables
  private var defaultContainerView: UIView!
  
  // MARK: - Container View Controllers
  private let embedIdentifier = "embedMessageCenter"
  private var messageCenterVC: MessageCenterViewController!
}

// MARK: - View Lifecycle
extension MessageCenterContainerViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureMessageCenterStyle()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case embedIdentifier:
      guard let viewController = segue.destination as? MessageCenterViewController else { break }
      messageCenterVC = viewController
    default:
      break
    }
  }
}

// MARK: - Private Methods
private extension MessageCenterContainerViewController {
  func configureMessageCenterStyle() {
    guard let value = RemoteStorage().retrieve(forKey: .messageCenterStyle) as? Int else { return configureOnlyCustom() }
    
    switch value {
    case 0:
      configureOnlyCustom()
    case 1:
      configureOnlyDefault()
    case 2:
      configureCustomAndDefault()
    default:
      break
    }
  }
  
  func configureCustomAndDefault() {
    configureAppboyContainer()
    defaultContainerView.isHidden = true
  }
  
  func configureOnlyCustom() {
    segmentedControlHeight.constant = 0
  }
  
  func configureOnlyDefault() {
    configureAppboyContainer()
    customContainerView.isHidden = true
    segmentedControlHeight.constant = 0
  }
  
  func configureAppboyContainer() {
    defaultContainerView = UIView()
    defaultContainerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(defaultContainerView)
    NSLayoutConstraint.activate([ defaultContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
        defaultContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
        
        defaultContainerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 0),
        defaultContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])

    let controller = ABKContentCardsTableViewController()
    addChild(controller)
    controller.view.translatesAutoresizingMaskIntoConstraints = false
    defaultContainerView.addSubview(controller.view)

    NSLayoutConstraint.activate([
        controller.view.leadingAnchor.constraint(equalTo: defaultContainerView.leadingAnchor),
        controller.view.trailingAnchor.constraint(equalTo: defaultContainerView.trailingAnchor),
        controller.view.topAnchor.constraint(equalTo: defaultContainerView.topAnchor),
        controller.view.bottomAnchor.constraint(equalTo: defaultContainerView.bottomAnchor)
        ])

    controller.didMove(toParent: self)
  }
}
