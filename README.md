<img src="https://github.com/Appboy/appboy-ios-sdk/blob/master/braze-logo.png" width="300" title="Braze Logo" />

# A Braze SDK implementiation Swift iOS Application

The focus of this application demonstrates how to decouple any dependencies on `Appboy-iOS-SDK`from the rest of your existing production code. One objective was for there to be only one `import Appboy-iOS-SDK` in the entire application.

All of the Braze-related dependencies are handled in the [AppboyManager.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze%20Demo/AppboyManager.swift) file that the existing production code calls into.

In doing do, this project demonstrates the abilities of how custom objects can be represented as Content Cards.

Objects can adopt the [ContentCardable](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze%20Demo/Model/ContentCardData.swift#L9) protocol which comes with the `ContentCardData` object and an initializer.
Upon receiving an array of `ABKContentCard` objects from the SDK, the corresponding `ABKContentCard` objects are [converted](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze%20Demo/AppboyManager.swift#L174) into a `Dictionary` of metadata that are used to instantiate your custom objects.

#### This demo highlights 4 uses cases:
1. Content Cards as Supplemental Content to an existing feed
    - [Tile.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze%20Demo/Model/Tile.swift#L18)
2. Content Cards that can be inserted/removed to/from an existing feed in real-time via silent push (device only)
3. Content Cards as a Message Center
    - [Message.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze%20Demo/Model/Message.swift#L7)
4. Content Cards as an Interact-able View
    - [Coupon.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze%20Demo/Model/Coupon.swift#L5)
#### Extra use cases:
1. Content Cards as an Inline Ad Banner
    - [Ad.swift](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze%20Demo/Model/Ad.swift#L5)
2. Content Cards that can be reordered in an existing feed in real-time via silent push (device only)

# Running the Project
1. [Install CocoaPods](http://guides.cocoapods.org/using/getting-started.html)
2. Run `pod install` in the root directory
3. Open the `Braze Demo.xcworkspace` to open the project.

# Using the Project
1. Replace "YOUR-API-KEY" with your Braze API key [here](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze%20Demo/AppboyManager.swift#L9)
2. Replace the Appboy/Endpoint value with your Appboy endpoint [here](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze%20Demo/Info.plist#L8)
3. For an API Triggered Campaign:
    - Replace "YOUR-CAMPAIGN-API-KEY" with your Braze campaign API key [here](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze%20Demo/ViewController/AppboySettingsViewController.swift#L84)
    - Replace "YOUR-CAMPAIGN-ID" with your Braze campaign ID [here](https://github.com/braze-inc/braze-growth-shares-ios-demo-app/blob/master/Braze%20Demo/ViewController/AppboySettingsViewController.swift#L83)
    
