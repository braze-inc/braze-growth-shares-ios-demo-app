<img src="https://github.com/Appboy/appboy-ios-sdk/blob/master/braze-logo.png" width="300" title="Braze Logo" />

# A Braze SDK implementiation Swift iOS Application

## Table of Contents
- [About Braze Demo](#about-braze-demo)
- [Content Cards](#content-cards)
- [In-App Messages](#in-app-messages)
- [Using the Project](#using-the-project)



## About Braze Demo
The focus of this application demonstrates how to decouple any dependencies on `Appboy-iOS-SDK`from the rest of your existing production code. One objective was for there to be only one `import Appboy-iOS-SDK` in the entire application.

All of the Braze-related dependencies are handled in the [BrazeManager.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/BrazeManager.swift) file that the existing production code calls into.

In doing do, this project demonstrates the abilities of how custom objects can be represented as Content Cards. 

In doing so, this project also demonstrates how to natively customize In-App Message with subclassed `ABKInAppMessageViewControllers`.

## Content Cards

Objects can adopt the [ContentCardable](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/Model/ContentCardData.swift#L9) protocol which comes with the `ContentCardData` object and an initializer.
Upon receiving an array of `ABKContentCard` objects from the SDK, the corresponding `ABKContentCard` objects are [converted](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/BrazeManager.swift#L174) into a `Dictionary` of metadata that are used to instantiate your custom objects.

### This demo highlights 4 Content Card uses cases:
1. Content Cards as Supplemental Content to an existing feed
    - [Tile.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/Model/Tile.swift#L18)
    - [Group.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/Model/Group.swift#L34)</br></br>
2. Content Cards as an Inline Ad Banner
    - [Ad.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/Model/Ad.swift#L5)</br></br>
3. Content Cards as a Message Center
    - [Message.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/Model/Message.swift#L7)</br></br>
4. Content Cards as an Interact-able View
    - [Coupon.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/Model/Coupon.swift#L5)</br></br> 
    
#### Extra use cases:
1. Content Cards that can be inserted/removed to/from an existing feed in real-time via [silent push](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/BrazeManager.swift#L84) (device only)
2. Content Cards that can be [reordered](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/DataSource/TileListDataSource.swift#L97) in an existing feed in real-time via silent push (device only)

## In-App Messages

Custom view controllers can represent in-app messages by subclassing `ABKInAppMessageViewController`. Due to the individusalitic nature of in-app messages, we can [mix and match](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/AppboyManager.swift#L131) displaying custom in-app messages and default in-app messages.

### This demo highlights 3 in-app message uses cases:
1. Slideup In-App Message with a modified resting point
    - [SlideFromBottomViewController.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze%20Demo/ViewController/In-App-Messages/SlideFromBottomViewController.swift)</br></br> 
2. Modal In-App Message as a dynamic list
    - [ModalPickerViewController.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze%20Demo/ViewController/In-App-Messages/ModalPickerViewController/ModalPickerViewController.swift)</br></br> 
3. Full In-App Message as a push primer with list of push tags
    - [FullListViewController.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/ViewController/In-App-Messages/FullListViewController/FullListViewController.swift)</br></br> 


## Using the Project
1. Replace "YOUR-API-KEY" with your Braze API key [here](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/AppboyManager.swift#L9)
2. Replace the Appboy/Endpoint value with your Appboy endpoint [here](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/Info.plist#L8)
3. Replace "YOUR-CONTENT-BLOCK-API-KEY" with your Braze Content Block API Key [here](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/ViewController/MessageCenterDetailViewController.swift#L99)
4. For an API Triggered Campaign:
    - Replace "YOUR-CAMPAIGN-API-KEY" with your Braze campaign API key [here](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/ViewController/Settings/ContentCardSettingsViewController.swift#L61)
    - Replace "YOUR-CAMPAIGN-ID" with your Braze campaign ID [here](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze-Demo/ViewController/Settings/ContentCardSettingsViewController.swift#L60)
