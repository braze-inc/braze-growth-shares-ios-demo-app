import UIKit
import AVKit

class ModalVideoViewController: ModalViewController {
  
  // MARK: - Outlets
  @IBOutlet private weak var videoPlayerContainer: UIView!
  
  // MARK: - Variables
  private let playerViewController = AVPlayerViewController()
  private var player: AVPlayer?
  
  override var nibName: String {
    return "ModalVideoViewController"
  }
}

// MARK: - View Lifecycle
extension ModalVideoViewController {
  /// Overriding loadView() from ABKInAppMessageModalViewController to provide our own view for the In-App Message
  override func loadView() {
    Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureVideoPlayer()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    view.alpha = 1
  }
  
  override func viewDidLayoutSubviews() {
    configureVideoPlayerFrame()
  }
}

// MARK: - Private
private extension ModalVideoViewController {
  func configureVideoPlayer() {
    guard let urlString = inAppMessage.extras?["video_url"] as? String,
          let url = URL(string: urlString) else { return }
    
    let asset = AVAsset(url: url)
    let playerItem = AVPlayerItem(asset: asset)
    player = AVPlayer(playerItem: playerItem)
    playerViewController.player = player
    
    addChild(playerViewController)
    videoPlayerContainer.addSubview(playerViewController.view)
    playerViewController.didMove(toParent: self)
  }
  
  /// Set the `AVPlayerViewController`'s  frame to the`videoPlayerContainer`'s bounds explicitly set the .xib file. Only update the value if the two are not equal.
  ///
  /// Called in `ViewDidLayoutSubviews()` after the view has been laid out.
  func configureVideoPlayerFrame() {
    guard playerViewController.view.frame != videoPlayerContainer.bounds else { return }
    
    playerViewController.view.frame = videoPlayerContainer.bounds
  }
}
