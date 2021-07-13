import AppboyUI

class OutOfTheBoxContentCardsTableViewController: ABKContentCardsTableViewController {
  
  override func registerTableViewCellClasses() {
    super.registerTableViewCellClasses()
    
    tableView.register(CustomCaptionedImageContentCardCell.self, forCellReuseIdentifier: "ABKCaptionedImageContentCardCell")
    tableView.register(CustomBannerContentCardCell.self, forCellReuseIdentifier: "ABKBannerContentCardCell")
    tableView.register(CustomClassicImageContentCardCell.self, forCellReuseIdentifier: "ABKClassicImageCardCell")
    tableView.register(CustomClassicContentCardCell.self, forCellReuseIdentifier: "ABKClassicCardCell")
  }
  
  // Filtering out all of the custom Content Cards - denoted by the `"class_type"` key-value pair.
  override func populateContentCards() {
    guard let cards = Appboy.sharedInstance()?.contentCardsController.contentCards else { return }
    var filteredCards = [ABKContentCard]()
    for card in cards {
      switch card {
      case let contentCard as ABKContentCard:
        if contentCard.extras?[ContentCardKey.classType.rawValue] == nil {
          filteredCards.append(contentCard)
        }
      default: break
      }
    }
    super.cards = (filteredCards as NSArray).mutableCopy() as? NSMutableArray
  }
}
