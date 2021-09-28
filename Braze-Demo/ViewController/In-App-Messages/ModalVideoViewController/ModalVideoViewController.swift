import UIKit
import Combine
import GroupActivities
import AVKit

@available(iOS 15, *)
class ModalVideoViewController: ModalViewController {
  
  // MARK: - Outlets
  @IBOutlet private weak var videoPlayerContainer: UIView!
  @IBOutlet private weak var sharePlayButton: UIButton!
  
  // MARK: - Actions
  @IBAction func sharePlayButtonPressed(_ sender: UIButton) {
    guard let mediaItem = mediaItem else { return }
    PlaybackCoordinator.shared.prepareToPlay(mediaItem)
  }
  
  // MARK: - Variables
  private let playerViewController = AVPlayerViewController()
  private let player = AVPlayer()
  private let groupStateObserver = GroupStateObserver()
  private var subscriptions = Set<AnyCancellable>()
  private var mediaItem: MediaItem?
  private var isEligibleForSharePlay: Bool = false {
      didSet {
        sharePlayButton.isHidden = !isEligibleForSharePlay
      }
    }
  
  // The group session to coordinate playback with.
  private var groupSession: GroupSession<MediaItemActivity>? {
    didSet {
      guard let session = groupSession else {
        // Stop playback if a session terminates.
        player.rate = 0
        return
      }
      // Coordinate playback with the active session.
      player.playbackCoordinator.coordinateWithSession(session)
    }
  }
  
  override var nibName: String {
    return "ModalVideoViewController"
  }
  
  /// Overriding loadView() from ABKInAppMessageModalViewController to provide our own view for the In-App Message
  override func loadView() {
    Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureVideoPlayer()
    configureSharePlay()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    view.alpha = 1
  }
  
  override func viewDidLayoutSubviews() {
    configureVideoPlayerFrame()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    groupSession?.leave()
  }
}

// MARK: - Private
@available(iOS 15, *)
private extension ModalVideoViewController {
  func configureVideoPlayer() {
    guard let urlString = inAppMessage.extras?["video_url"] as? String,
          let url = URL(string: urlString) else { return }
    
    let videoTitle = inAppMessage.extras?["video_title"] as? String
    mediaItem = MediaItem(title: videoTitle ?? "Video Content", url: url)
    
    let asset = AVAsset(url: url)
    let playerItem = AVPlayerItem(asset: asset)
    player.replaceCurrentItem(with: playerItem)
    playerViewController.player = player
    
    addChild(playerViewController)
    videoPlayerContainer.addSubview(playerViewController.view)
    playerViewController.didMove(toParent: self)
  }
  
  func configureSharePlay() {
    // SharePlay button eligibility
    groupStateObserver.$isEligibleForGroupSession
      .receive(on: DispatchQueue.main)
      .assign(to: \.isEligibleForSharePlay, on: self)
      .store(in: &subscriptions)

    // The movie subscriber.
    PlaybackCoordinator.shared.$enqueuedMediaItem
      .receive(on: DispatchQueue.main)
      .compactMap { $0 }
      .assign(to: \.mediaItem, on: self)
      .store(in: &subscriptions)

    // The group session subscriber.
    PlaybackCoordinator.shared.$groupSession
      .receive(on: DispatchQueue.main)
      .assign(to: \.groupSession, on: self)
      .store(in: &subscriptions)

    player.publisher(for: \.timeControlStatus, options: [.initial])
      .receive(on: DispatchQueue.main)
      .sink { _ in }
      .store(in: &subscriptions)
    
    // Observe audio session interruptions.
    NotificationCenter.default
      .publisher(for: AVAudioSession.interruptionNotification)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] notification in

        // Wrap the notification in helper type that extracts the interruption type and options.
        guard let result = InterruptionResult(notification) else { return }

        // Resume playback, if appropriate.
        if result.type == .ended && result.options == .shouldResume {
          self?.player.play()
        }
    }.store(in: &subscriptions)
  }
  
  /// Set the `AVPlayerViewController`'s  frame to the`videoPlayerContainer`'s bounds explicitly set the .xib file. Only update the value if the two are not equal.
  ///
  /// Called in `ViewDidLayoutSubviews()` after the view has been laid out.
  func configureVideoPlayerFrame() {
    guard playerViewController.view.frame != videoPlayerContainer.bounds else { return }
    
    playerViewController.view.frame = videoPlayerContainer.bounds
  }
}
