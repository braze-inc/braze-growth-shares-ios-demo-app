import SwiftUI
import Combine

@MainActor
final class HomeViewModel: NSObject, ObservableObject {
  @Published var meta: HomeMetaData = HomeMetaData.empty
  
  func requestHomeData() async {
    self.meta = await ContentOperationQueue(classTypes: [.home(.pill), .home(.bottle), .home(.miniBottle)]).downloadContent()
  }
  
  var header: Header {
    return  meta.data.attributes.header
  }
  
  var pills: [HomeItem] {
    return meta.data.attributes.pills
  }
  
  var bottles: [HomeItem] {
    return  meta.data.attributes.bottles
  }
  
  var composites: [Composite] {
    return  meta.data.attributes.composites
  }
}
