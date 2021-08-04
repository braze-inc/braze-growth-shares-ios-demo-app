<img src="https://github.com/Appboy/appboy-ios-sdk/blob/master/braze-logo.png" width="300" title="Braze Logo" />

# A Braze SDK implementiation Swift iOS Application

## Table of Contents
- [About Braze Demo](#about-braze-demo)
- [Content Cards](#content-cards)
- [In-App Messages](#in-app-messages)
- [Push Notifications (Content Extension Notifications)](#push-notifications)
- [Using the Project](#using-the-project)



## About Braze Demo
The focus of this application demonstrates how to decouple any dependencies on `Appboy-iOS-SDK`from the rest of your existing production code. One objective was for there to be only one `import Appboy-iOS-SDK` in the entire application.

All of the Braze-related dependencies are handled in the [BrazeManager.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/BrazeManager.swift) file that the existing production code calls into.

In doing so, this project demonstrates the abilities of how custom objects can be represented as Content Cards. 

In doing so, this project also demonstrates how to natively customize In-App Message with subclassed `ABKInAppMessageViewControllers`.

## Content Cards

Objects can adopt the [ContentCardable](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/Model/Content-Cards/ContentCardData.swift#L9) protocol which comes with the `ContentCardData` object and an initializer.
Upon receiving an array of `ABKContentCard` objects from the SDK, the corresponding `ABKContentCard` objects are [converted](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/BrazeManager.swift#L248) into a `Dictionary` of metadata that are used to instantiate your custom objects.

### This demo highlights 4 Content Card use cases:
1. Content Cards as Supplemental Content to an existing feed
    - [Tile.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/Model/Content-Cards/Tile.swift#L18)
    - [Group.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/Model/Content-Cards/Group.swift#L34)</br></br>
2. Content Cards as an Inline Ad Banner
    - [Ad.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/Model/Content-Cards/Ad.swift#L5)</br></br>
3. Content Cards as a Message Center
    - [Message.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/Model/Content-Cards/Message.swift#L7)</br></br>
4. Content Cards as an Interact-able View
    - [Coupon.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/Model/Content-Cards/Coupon.swift#L5)</br></br> 
    
#### Extra use cases:
1. Content Cards that can be inserted/removed to/from an existing feed in real-time via [silent push](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/BrazeManager.swift#L76) (device only)
2. Content Cards that can be [reordered](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/DataSource/TileListDataSource.swift#L97) in an existing feed in real-time via silent push (device only)

## In-App Messages

Custom view controllers can represent in-app messages by subclassing `ABKInAppMessageViewController`. Due to the individusalitic nature of in-app messages, we can [mix and match](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/BrazeManager.swift#L155) displaying custom in-app messages and default in-app messages.

### This demo highlights 5 in-app message use cases:
1. Slideup In-App Message with a modified resting point
    - [SlideFromBottomViewController.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/ViewController/In-App-Messages/SlideFromBottomViewController.swift)</br></br> 
2. Modal In-App Message as a dynamic list
    - [ModalPickerViewController.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/ViewController/In-App-Messages/ModalPickerViewController/ModalPickerViewController.swift)</br></br> 
3. Modal In-App Message as a native video player
    - [ModalVideoViewController.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/ViewController/In-App-Messages/ModalVideoViewController/ModalVideoViewController.swift)</br></br> 
4. Full In-App Message as a Push Notifications primer with list of push tags
    - [FullListViewController.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/ViewController/In-App-Messages/FullListViewController/FullListViewController.swift)</br></br>
5. Full In-App Message as an interactive App Tracking Transparency primer
    - [FullPermissionViewController.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/ViewController/In-App-Messages/FullPermissionViewController/FullPermissionViewController.swift)</br></br>  

## Push Notifications

Custom interfaces can be added to Push Notifications with the help of Notification Content Extensions. 

### This demo highlight 3 Notification Content Extension use cases:
1. Interactive Push Notification (Match Game)
    - [(Match Game) NotificationViewController.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo-Match-Game-Content-Extension/ViewController/NotificationViewController.swift)</br></br> 
2. Personalized Push Notification (Braze LAB Progress)
    - [(Braze LAB Progress) NotificationViewController.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo-LAB-Progress-Content-Extension/ViewController/NotificationViewController.swift)</br></br> 
3. Information Capture Push Notification (Register Email)
    - [(Register Email) NotificationViewController.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo-LAB-Register-Content-Extension/NotificationViewController.swift)</br></br> 


## Using the Project
1. Replace "YOUR-API-KEY" with your Braze API key [here](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/BrazeManager.swift#L9)
2. Replace the Appboy/Endpoint value with your Appboy endpoint [here](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/Info.plist#L8)
3. Replace "YOUR-CONTENT-BLOCK-API-KEY" with your Braze Content Block API Key [here](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/ViewController/MessageCenterDetailViewController.swift#L99)
4. For an API Triggered Campaign:
    - Replace "YOUR-CAMPAIGN-API-KEY" with your Braze campaign API key [here](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/ViewController/Settings/ContentCardSettingsViewController.swift#L61)
    - Replace "YOUR-CAMPAIGN-ID" with your Braze campaign ID [here](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/ViewController/Settings/ContentCardSettingsViewController.swift#L60)
5. For Out-of-the-Box Content Cards:
    - Replace "YOUR-BANNER-CAMPAIGN-ID" with your Banner Campaign ID [here](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/Model/Content-Cards/OutOfTheBoxContentCardConfigurationData.swift#L34)
    - Replace "YOUR-CAPTIONED-IMAGE-CAMPAIGN-ID" with your Captioned Image Campaign ID [here](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/Model/Content-Cards/OutOfTheBoxContentCardConfigurationData.swift#L35)
    - Replace "YOUR-CLASSIC-CAMPAIGN-ID" with your Classic Campaign ID [here](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/Model/Content-Cards/OutOfTheBoxContentCardConfigurationData.swift#L36)

