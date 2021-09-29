import Foundation
import Combine
import GroupActivities
import AVKit
import AppboyKit
import AppboyUI

@available(iOS 15.0, *)
class PlaybackCoordinator {
  static let shared = PlaybackCoordinator()
  private var groupSessionSubscriptions = Set<AnyCancellable>()
  private var mediaItemSubscriptions = Set<AnyCancellable>()
  
  private var selectedMediaItem: MediaItem? {
    didSet {
      // Ensure the UI selection always represents the currently playing media.
      guard let _ = selectedMediaItem else { return }

      if !BrazeManager.shared.inAppMessageCurrentlyVisible {
        BrazeManager.shared.logCustomEvent("Video Pressed")
      }
    }
  }

  // Published values that the player, and other UI items, observe.
  @Published var enqueuedMediaItem: MediaItem?
  @Published var groupSession: GroupSession<MediaItemActivity>?

  private init() {
    Task.init {

      // Await new sessions to watch movies together.
      for await groupSession in MediaItemActivity.sessions() {
        // Set the app's active group session.
        self.groupSession = groupSession

        // Remove previous subscriptions.
        groupSessionSubscriptions.removeAll()

        // Observe changes to the session state.
        groupSession.$state.sink { [weak self] state in
          if case .invalidated = state {
            // Set the groupSession to nil to publish
            // the invalidated session state.
            self?.groupSession = nil
            self?.groupSessionSubscriptions.removeAll()
          }
        }.store(in: &groupSessionSubscriptions)

        // Join the session to participate in playback coordination.
        groupSession.join()

        // Observe when the local user or a remote participant starts an activity.
        groupSession.$activity.sink { [weak self] activity in
          // Set the movie to enqueue it in the player.
          self?.enqueuedMediaItem = activity.mediaItem
        }.store(in: &groupSessionSubscriptions)
      }
    }
  }
}

// MARK: - Public Methods
@available(iOS 15.0, *)
extension PlaybackCoordinator {
  // Prepares the app to play the movie.
  func prepareToPlay(_ selectedMediaItem: MediaItem) {
    // Return early if the app enqueues the movie.
    guard enqueuedMediaItem != selectedMediaItem else { return }

    if let groupSession = groupSession {
      // If there's an active session, create an activity for the new selection.
      if groupSession.activity.mediaItem != selectedMediaItem {
        groupSession.activity = MediaItemActivity(mediaItem: selectedMediaItem)
      }
    } else {
        Task.init {
          // Create a new activity for the selected movie.
          let activity = MediaItemActivity(mediaItem: selectedMediaItem)
          // Await the result of the preparation call.
          switch await activity.prepareForActivation() {
          case .activationDisabled:
            // Playback coordination isn't active, or the user prefers to play the
            // movie apart from the group. Enqueue the movie for local playback only.
            self.enqueuedMediaItem = selectedMediaItem
          case .activationPreferred:
            // The user prefers to share this activity with the group.
            // The app enqueues the movie for playback when the activity starts.
            do {
              _ = try await activity.activate()
            } catch {
              print("Unable to activate the activity: \(error)")
            }
          case .cancelled:
            // The user cancels the operation. Do nothing.
            break
          default: ()
        }
      }
    }
  }

  // Launch a video from SharePlay if enqueued.
  func launchVideoPlayerIfNecessary() {
    $enqueuedMediaItem
      .receive(on: DispatchQueue.main)
      .compactMap { $0 }
      .assign(to: \.selectedMediaItem, on: self)
      .store(in: &mediaItemSubscriptions)
  }
  
  // Clear activity when user leaves
  func leave() {
    groupSession = nil
    enqueuedMediaItem = nil
  }
}

struct MediaItem: Hashable, Codable {
  let title: String
  let url: URL
}

@available(iOS 15, *)
struct MediaItemActivity: GroupActivity {
  static let activityIdentifier = "com.book-demo.GroupWatching"

  let mediaItem: MediaItem

  var metadata: GroupActivityMetadata {
    var metadata = GroupActivityMetadata()
    metadata.type = .watchTogether
    metadata.title = mediaItem.title
    metadata.fallbackURL = mediaItem.url
    return metadata
  }
}

struct InterruptionResult {
  let type: AVAudioSession.InterruptionType
  let options: AVAudioSession.InterruptionOptions

  init?(_ notification: Notification) {
    // Determine the interruption type and options.
    guard let type = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? AVAudioSession.InterruptionType,
    let options = notification.userInfo?[AVAudioSessionInterruptionOptionKey] as? AVAudioSession.InterruptionOptions else {
      return nil
    }

    self.type = type
    self.options = options
  }
}
