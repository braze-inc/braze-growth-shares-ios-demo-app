struct Summary: ContentCardable {
  private(set) var contentCardData: ContentCardData?
  let header: String
  let body: String
  let timeStamp: String
  let actionText: String
}

// MARK: - Content Card Initializer
extension Summary {
  init?(metaData: [ContentCardKey : Any], classType contentCardClassType: ContentCardClassType) {
    self.init(contentCardData: nil, header: "", body: "", timeStamp: "", actionText: "")
  }
}
