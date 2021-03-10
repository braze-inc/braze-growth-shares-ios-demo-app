import SwiftUI

final class ModelData: ObservableObject {
  @Published var summaries: [Summary] = [Summary(contentCardData: nil, header: "Your daily summary is ready", body: "Our latest update includes the ability to test notification content extensions!", timeStamp: "2hr ago", actionText: "Watch Now")]
}
