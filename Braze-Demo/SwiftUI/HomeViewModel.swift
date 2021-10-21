import SwiftUI

final class HomeViewModel: NSObject, ObservableObject {
  @Published var data: HomeData?
  
  private lazy var result: APIResult<HomeData> = {
    return LocalDataCoordinator().loadData(fileName: "Home-List", withExtension: "json")
  }()
  
  func requestHomeData() {
    switch result {
    case .success(let data):
      self.data = data
    case .failure(let error):
      print(error)
    }
  }
  
  var pills: [Pill] {
    return data?.pills ?? []
  }
  
  var bottles: [Bottle] {
    return data?.bottles ?? []
  }
  
  var composites: [Composite] {
    return data?.composites ?? []
  }
}

struct HomeData: Codable {
  let pills: [Pill]
  let bottles: [Bottle]
  let composites: [Composite]
}

struct Pill: Codable, Hashable {
  let title: String
}

struct Bottle: Codable, Hashable {
  let title: String
}

struct Composite: Codable, Hashable {
  let title: String
  let subtitle: String
  let miniBottles: [Bottle]
}
