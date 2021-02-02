<img src="https://github.com/Appboy/appboy-ios-sdk/blob/master/braze-logo.png" width="300" title="Braze Logo" />

# A Braze SDK implementiation Swift iOS Application

## Table of Contents
- [About Braze Demo](#about-braze-demo)
- [Content Cards](#content-cards)
- [In-App Messages](#in-app-messages)
- [Using the Project](#using-the-project)



### About Braze Demo
The focus of this application demonstrates how to decouple any dependencies on `Appboy-iOS-SDK`from the rest of your existing production code. One objective was for there to be only one `import Appboy-iOS-SDK` in the entire application.

All of the Braze-related dependencies are handled in the [AppboyManager.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze%20Demo/AppboyManager.swift) file that the existing production code calls into.

In doing do, this project demonstrates the abilities of how custom objects can be represented as Content Cards. This project also demonstrates how to natively customize In-App Message with subclassed `ABKInAppMessageViewControllers`.

## Content Cards

Objects can adopt the [ContentCardable](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze%20Demo/Model/ContentCardData.swift#L9) protocol which comes with the `ContentCardData` object and an initializer.
Upon receiving an array of `ABKContentCard` objects from the SDK, the corresponding `ABKContentCard` objects are [converted](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze%20Demo/AppboyManager.swift#L174) into a `Dictionary` of metadata that are used to instantiate your custom objects.

### This demo highlights 4 uses cases:
1. Content Cards as Supplemental Content to an existing feed
    - [Tile.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze%20Demo/Model/Tile.swift#L18)</br></br>
    <img src="https://i.imgur.com/WtubJL9.png" width="200" height="420" />
2. Content Cards as an Inline Ad Banner
    - [Ad.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze%20Demo/Model/Ad.swift#L5)</br></br>
    <img src="https://i.imgur.com/hhGP1I8.png" width="200" height="420" />
3. Content Cards as a Message Center
    - [Message.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze%20Demo/Model/Message.swift#L7)</br></br>
    <img src="https://s8.gifyu.com/images/ezgif-5-7789033c8332.gif" width="200" height="420" />
4. Content Cards as an Interact-able View
    - [Coupon.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze%20Demo/Model/Coupon.swift#L5)</br></br>
    <img src="https://i.imgur.com/2zvaIWS.gif" width="200" height="420" />
    
#### Extra use cases:
1. Content Cards that can be inserted/removed to/from an existing feed in real-time via silent push (device only)
2. Content Cards that can be reordered in an existing feed in real-time via silent push (device only)

## In-App Messages
1. Slideup In-App Message with a modified resting point
2. Modal In-App Message as a dynamic list
3. Full In-App Message as a push primer with list of push tags


# Using the Project
1. Replace "YOUR-API-KEY" with your Braze API key [here](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze%20Demo/AppboyManager.swift#L9)
2. Replace the Appboy/Endpoint value with your Appboy endpoint [here](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze%20Demo/Info.plist#L8)
3. Replace "YOUR-CONTENT-BLOCK-API-KEY" with your Braze Content Block API Key [here](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze%20Demo/ViewController/MessageCenterDetailViewController.swift#L99)
4. For an API Triggered Campaign:
    - Replace "YOUR-CAMPAIGN-API-KEY" with your Braze campaign API key [here](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze%20Demo/ViewController/Settings/ContentCardSettingsViewController.swift#L61)
    - Replace "YOUR-CAMPAIGN-ID" with your Braze campaign ID [here](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze%20Demo/ViewController/Settings/ContentCardSettingsViewController.swift#L62)
