import UIKit
import AppboyUI
import AdSupport
import AppTrackingTransparency

class BrazeManager: NSObject {
  static let shared = BrazeManager()
#warning("Please enter your API key below")
  private let apiKey = "YOUR-API-KEY"
#warning("Please enter your API key above")
  private var appboyOptions: [String: Any] {
    return [
      ABKEndpointKey: endpointToUse,
      ABKIDFADelegateKey: BrazeIDFADelegate(),
      ABKMinimumTriggerTimeIntervalKey: 0,
      ABKPushStoryAppGroupKey : "group.com.braze.book-demo"
    ]
  }
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
        
    Appboy.start(withApiKey: apiKeyToUse, in: application, withLaunchOptions: launchOptions, withAppboyOptions: appboyOptions)
    
    // MARK: - Push Notifications
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, error) in
      Appboy.sharedInstance()?.pushAuthorization(fromUserNotificationCenter: granted)
    }
    UIApplication.shared.registerForRemoteNotifications()
    
    // MARK: - In-App Messages
    Appboy.sharedInstance()?.inAppMessageController.inAppMessageUIController?.setInAppMessageUIDelegate?(self)
    
    // MARK: - Analytics from Notifcation Content Extensions
    logPendingCustomEventsIfNecessary()
    logPendingCustomAttributesIfNecessary()
    logPendingUserAttributesIfNecessary()
  }
  
  /// Initialized as the value for the ABKIDFADelegateKey.
  private class BrazeIDFADelegate: NSObject, ABKIDFADelegate {
    func advertisingIdentifierString() -> String {
      return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }

    func isAdvertisingTrackingEnabledOrATTAuthorized() -> Bool {
      return ATTrackingManager.trackingAuthorizationStatus ==  ATTrackingManager.AuthorizationStatus.authorized
    }
  }
}

// MARK: - User
extension BrazeManager {
  private var user: ABKUser? {
    return Appboy.sharedInstance()?.user
  }
  
  var userId: String? {
     return user?.userID
   }
    
  func changeUser(_ userId: String) {
    Appboy.sharedInstance()?.changeUser(userId)
  }
}

// MARK: - Push
extension BrazeManager {
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let appboyCategories = ABKPushUtils.getAppboyUNNotificationCategorySet()
    UNUserNotificationCenter.current().setNotificationCategories(appboyCategories)
    
    Appboy.sharedInstance()?.registerDeviceToken(deviceToken)
  }
  
  ///Remote notifications are set up in this demo to show how silent push can be used in conjunction with Content Cards to influence the UI/UX of the application.
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    Appboy.sharedInstance()?.register(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    
    if let priority = userInfo[PushNotificationKey.homeTilePriority.rawValue] as? String {
      RemoteStorage().store(priority, forKey: .homeTilePriority)
    }
    
    if let updateHomeTo = userInfo[PushNotificationKey.refreshHome.rawValue] as? String {
      switch updateHomeTo {
      case "Default":
        RemoteStorage().removeObject(forKey: .homeTilePriority)
        NotificationCenter.default.post(name: .defaultAppExperience, object: nil)
      case "Content Card":
        NotificationCenter.default.post(name: .homeScreenContentCard, object: nil)
      default:
        break
      }
    }
    
    if let eventName = userInfo[PushNotificationKey.eventName.rawValue] as? String {
      logCustomEvent(eventName)
    }
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    Appboy.sharedInstance()?.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
  }
}

// MARK: - Analytics
extension BrazeManager {
  func setCustomAttributeArrayWithKey(_ key: String, andValue valueArray: [String]) {
    user?.setCustomAttributeArrayWithKey(key, array: valueArray)
  }
  
  func addToCustomAttributeArrayWithKey(_ key: String, andValue valueArray: [String]) {
    valueArray.forEach {
      user?.addToCustomAttributeArray(withKey: key, value: $0)
    }
  }
  
  func setCustomAttributeWithKey(_ key: String, andValue value: Any?) {
    guard let value = value else { return }
    
    switch value.self {
    case let value as Date:
      user?.setCustomAttributeWithKey(key, andDateValue: value)
    case let value as Bool:
      user?.setCustomAttributeWithKey(key, andBOOLValue: value)
    case let value as String:
      user?.setCustomAttributeWithKey(key, andStringValue: value)
    case let value as Double:
      user?.setCustomAttributeWithKey(key, andDoubleValue: value)
    case let value as Int:
      user?.setCustomAttributeWithKey(key, andIntegerValue: value)
    default:
      return
    }
  }
  
  func logCustomEvent(_ eventName: String, withProperties properties: [AnyHashable: Any]? = nil) {
    Appboy.sharedInstance()?.logCustomEvent(eventName, withProperties: properties)
  }
  
  func logPurchase(productIdentifier: String, inCurrency currency: String, atPrice price: String, withQuantity quantity: Int) {
    Appboy.sharedInstance()?.logPurchase(productIdentifier, inCurrency: currency, atPrice: NSDecimalNumber(string: price), withQuantity: UInt(quantity))
  }
}

// MARK: - In-App Messages
extension BrazeManager {
  func isInAppMessageSlideFromTop(_ inAppMessage: ABKInAppMessage) -> Bool {
    guard let slideup = inAppMessage as? ABKInAppMessageSlideup else { return false }
    return slideup.inAppMessageSlideupAnchor == .fromTop
  }
}

// MARK: - ABKInAppMessage UI Delegate
extension BrazeManager: ABKInAppMessageUIDelegate {
  func inAppMessageViewControllerWith(_ inAppMessage: ABKInAppMessage) -> ABKInAppMessageViewController {
    switch inAppMessage {
    case is ABKInAppMessageSlideup:
      return slideupViewController(inAppMessage: inAppMessage)
    case is ABKInAppMessageModal:
      return modalViewController(inAppMessage: inAppMessage)
    case is ABKInAppMessageFull:
      return fullViewController(inAppMessage: inAppMessage)
    case is ABKInAppMessageHTML:
      return ABKInAppMessageHTMLViewController(inAppMessage: inAppMessage)
    default:
      return ABKInAppMessageViewController(inAppMessage: inAppMessage)
    }
  }
}

// MARK: - Content Cards
extension BrazeManager {
  var contentCards: [ABKContentCard]? {
    return Appboy.sharedInstance()?.contentCardsController.contentCards as? [ABKContentCard]
  }
  
  /// Registers an observer to the Content Card Processed Appboy dependent Notification.
  /// - parameter observer: The listener of the `ABKContentCardsProcessed Notification`.
  /// - parameter selector: The method specified by selector must have one and only one argument (an instance of Notification).
  func addObserverForContentCards(observer: Any, selector: Selector) {
    NotificationCenter.default.addObserver(observer, selector: selector,
    name:NSNotification.Name.ABKContentCardsProcessed, object: nil)
  }
  
  func requestContentCardsRefresh() {
    Appboy.sharedInstance()?.requestContentCardsRefresh()
  }
  
  /// Parses the Appboy dependent information from `Notification.userInfo` dictionary and converts the `ABKContentCard` objects into `ContentCardable` objects.
  /// - parameter notification: A container for information broadcast through a notification center to all registered observers.
  /// - parameter classTypes: The filter to determine what custom objects to be returned.
  /// - Returns: An array of converted `ABKContentCard`s for the corresponding `classTypes`.
  func handleContentCardsUpdated(_ notification: Notification, for classTypes: [ContentCardClassType]) -> [ContentCardable] {
    guard let updateIsSuccessful = notification.userInfo?[ABKContentCardsProcessedIsSuccessfulKey] as? Bool, updateIsSuccessful, let cards = contentCards else { return [] }
            
    return convertContentCards(cards, for: classTypes)
  }
  
  /// Logs an` ABKContentCard` clicked.
  /// - parameter idString: Identifier used to retrieve an `ABKContentCard`.
  func logContentCardClicked(idString: String?) {
    guard let contentCard = getContentCard(forString: idString) else { return }
    
    contentCard.logContentCardClicked()
  }
  
  /// Logs an` ABKContentCard` impression.
  /// - parameter idString: Identifier used to retrieve an `ABKContentCard`.
  func logContentCardImpression(idString: String?) {
    guard let contentCard = getContentCard(forString: idString) else { return }
    
    contentCard.logContentCardImpression()
  }
  
  /// Logs an `ABKContentCard` dismissed.
  /// - parameter idString: Identifier used to retrieve an ABKContentCard.
  func logContentCardDismissed(idString: String?) {
    guard let contentCard = getContentCard(forString: idString) else { return }
    
    contentCard.logContentCardDismissed()
  }
  
  /// Retrieves an `ABKContentCard` from the `Appboy.sharedInstance()?.contentCardsController.contentCards` array.
  /// - parameter idString: Identifier used to retrieve an ABKContentCard.
  /// - Returns: An `ABKContentCard` object with a matching `idString`
  private func getContentCard(forString idString: String?) -> ABKContentCard? {
    return contentCards?.first(where: { $0.idString == idString })
  }
}

// MARK: - ABKUIUtils
extension BrazeManager {
  var activeApplicationViewController: UIViewController {
    return ABKUIUtils.activeApplicationViewController
  }
}

// MARK: - Private Methods
private extension BrazeManager {
  /// Helper method to convert `ABKContentCard` objects to `ContentCardable` objects.
  ///
  /// The variables of `ABKContentCard` are parsed into a dictionary to be used as the `metaData` parameter for the `ContentCardable` initializer. All key-value pairs from the Braze dashboard are represented in the `extras` variable.
  ///
  /// The `ContentCardKey` is used to identify the values from each `ABKContentCard` variable.
  /// - parameter cards: Array of Content Cards.
  /// - parameter classTypes: Used to determine what Content Cards to convert. If a Content Card's classType does not match any of the classTypes, it will skip converting that `ABKContentCard`.
  /// - Returns: An array of converted `ABKContentCard`s for the corresponding `classTypes`.
  func convertContentCards(_ cards: [ABKContentCard], for classTypes: [ContentCardClassType]) -> [ContentCardable] {
    var contentCardables: [ContentCardable] = []
    for card in cards {
      let classTypeString = card.extras?[ContentCardKey.classType.rawValue] as? String
      let classType = ContentCardClassType(rawType: classTypeString)
      guard classTypes.contains(classType) else { continue }
      
      var metaData: [ContentCardKey: Any] = [:]
      switch card {
      case let banner as ABKBannerContentCard:
        metaData[.image] = banner.image
      case let captioned as ABKCaptionedImageContentCard:
        metaData[.title] = captioned.title
        metaData[.cardDescription] = captioned.cardDescription
        metaData[.image] = captioned.image
      case let classic as ABKClassicContentCard:
        metaData[.title] = classic.title
        metaData[.cardDescription] = classic.cardDescription
        metaData[.image] = classic.image
      default:
        print("Invalid type from an ABKContentCard: \(card)")
      }
      
      metaData[.idString] = card.idString
      metaData[.created] = card.created
      metaData[.dismissible] = card.dismissible
      metaData[.urlString] = card.urlString
      metaData[.extras] = card.extras
     
      if let contentCardable = contentCardable(with: metaData, for: classType) {
        contentCardables.append(contentCardable)
      }
    }
    return contentCardables
  }
  
  /// Instantiates a custom object that confroms to the `ContentCardable` protocol.
  ///
  /// - parameter metaData: `Dictionary` used to instantiate the custom object.
  /// - parameter classType: Determines the custom object to instantiate.
  /// - Returns: A custom object for the corresponding `classType`
  func contentCardable(with metaData: [ContentCardKey: Any], for classType: ContentCardClassType) -> ContentCardable? {
    switch classType {
    case .ad:
      return Ad(metaData: metaData, classType: classType)
    case .coupon:
      return Coupon(metaData: metaData, classType: classType)
    case .item(.group):
      return Group(metaData: metaData, classType: classType)
    case .item(.tile):
      return Tile(metaData: metaData, classType: classType)
    case .message(.fullPage):
      return FullPageMessage(metaData: metaData, classType: classType)
    case .message(.webView):
      return WebViewMessage(metaData: metaData, classType: classType)
    default:
      return nil
    }
  }
}

// MARK: - Slideup In-App Message
class SlideupViewController: ABKInAppMessageSlideupViewController {}

// MARK: - Modal In-App Message
class ModalViewController: ABKInAppMessageModalViewController {
  
  // MARK: - Outlets
  @IBOutlet private weak var primaryButton: ABKInAppMessageUIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let immersiveMessage = inAppMessage as? ABKInAppMessageImmersive, let buttons = immersiveMessage.buttons {
      switch buttons.count {
      case 1:
        primaryButton.titleLabel?.text = buttons[0].buttonText
      case 2:
        primaryButton.titleLabel?.text = buttons[1].buttonText
      default:
        break
      }
    }
  }
}

// MARK: - Full In-App Message
class FullViewController: ABKInAppMessageFullViewController {}

// MARK: - In-App Message View Controller Helpers
private extension BrazeManager {
  func slideupViewController(inAppMessage: ABKInAppMessage) -> ABKInAppMessageSlideupViewController {
    if isInAppMessageSlideFromTop(inAppMessage) || activeApplicationViewController.topMostViewController() is UIAlertController {
      return ABKInAppMessageSlideupViewController(inAppMessage: inAppMessage)
    } else {
      return SlideFromBottomViewController(inAppMessage: inAppMessage)
    }
  }
  
  func modalViewController(inAppMessage: ABKInAppMessage) -> ABKInAppMessageModalViewController {
    switch inAppMessage.extras?[InAppMessageKey.viewType.rawValue] as? String {
    case InAppMessageViewType.picker.rawValue:
      return ModalPickerViewController(inAppMessage: inAppMessage)
    default:
      return ABKInAppMessageModalViewController(inAppMessage: inAppMessage)
    }
  }
  
  func fullViewController(inAppMessage: ABKInAppMessage) -> ABKInAppMessageFullViewController {
    switch inAppMessage.extras?[InAppMessageKey.viewType.rawValue] as? String {
    case InAppMessageViewType.tableList.rawValue:
      return FullListViewController(inAppMessage: inAppMessage)
    case InAppMessageViewType.permission.rawValue:
      return FullPermissionViewController(inAppMessage: inAppMessage)
    default:
      return ABKInAppMessageFullViewController(inAppMessage: inAppMessage)
    }
  }
}

// MARK: - Notification Content Extension Analytics
private extension BrazeManager {
  /// Loops through an array of saved custom event data saved from storage. In the loop, the value `"Event Name`" is explicity checked against and the rest of the keys/values are added as the `properties` dictionary. Once the events are logged, they are cleared from storage.
  func logPendingCustomEventsIfNecessary() {
    let remoteStorage = RemoteStorage(storageType: .suite)
    guard let pendingEvents = remoteStorage.retrieve(forKey: .pendingCustomEvents) as? [[String: Any]] else { return }
    
    for event in pendingEvents {
      var eventName: String?
      var properties: [AnyHashable: Any] = [:]
      for (key, value) in event {
        if key == PushNotificationKey.eventName.rawValue {
          if let eventNameValue = value as? String {
            eventName = eventNameValue
          } else {
            print("Invalid type for event_name key")
          }
        } else {
          properties[key] = value
        }
      }
      
      if let eventName = eventName {
        logCustomEvent(eventName, withProperties: properties)
      }
    }
    
    remoteStorage.removeObject(forKey: .pendingCustomEvents)
  }
  
  /// Loops through an array of saved custom attribute data saved from storage. Each `key` is set as the attribute key with a corresponding `value`. Once the attributes are logged, they are cleared from storage.
  ///
  /// `key` represents the attribute key and `value` represents the attribute value.
  func logPendingCustomAttributesIfNecessary() {
    let remoteStorage = RemoteStorage(storageType: .suite)
    guard let pendingAttributes = remoteStorage.retrieve(forKey: .pendingCustomAttributes) as? [[String: Any]] else { return }
    
    pendingAttributes.forEach { setCustomAttributesWith(keysAndValues: $0) }
    
    remoteStorage.removeObject(forKey: .pendingCustomAttributes)
  }
  
  func setCustomAttributesWith(keysAndValues: [String: Any]) {
    for (key, value) in keysAndValues {
      if let value = value as? [String] {
        setCustomAttributeArrayWithKey(key, andValue: value)
      } else {
        setCustomAttributeWithKey(key, andValue: value)
      }
    }
  }
  
  /// Loops through an array of saved user attribute data saved from storage. In the loop, the data is decoded to represent a `UserAttribute` object. Based on the type of `UserAttribute`, the field is set accordingly with the associated value. Once the attributes are logged, they are cleared from storage.
  func logPendingUserAttributesIfNecessary() {
    let remoteStorage = RemoteStorage(storageType: .suite)
    guard let pendingAttributes = remoteStorage.retrieve(forKey: .pendingUserAttributes) as? [Data] else { return }
    
    for attributeData in pendingAttributes {
      guard let userAttribute = try? PropertyListDecoder().decode(UserAttribute.self, from: attributeData) else { continue }
      
      switch userAttribute {
      case .email(let email):
        user?.email = email
      }
    }
    
    remoteStorage.removeObject(forKey: .pendingUserAttributes)
  }
}

// MARK: - Environment
extension BrazeManager {
  var apiKeyToUse: String {
    let overrideApiKey = RemoteStorage().retrieve(forKey: .overrideApiKey) as? String
    return overrideApiKey ?? apiKey
  }
  
  var endpointToUse: String {
    let overrideEndpoint = RemoteStorage().retrieve(forKey: .overrideEndpoint) as? String
    return overrideEndpoint ?? endpoint ?? ""
  }
  
  private var endpoint: String? {
    guard let appboyPlist = Bundle.main.infoDictionary?["Braze"] as? [AnyHashable: Any] else { return nil }
    return appboyPlist["Endpoint"] as? String
  }
}
