# A Braze SDK implementiation Swift iOS Application

The focus of this application demonstrates how to decouple any dependencies on `Appboy-iOS-SDK`from the rest of your existing production code. One objective was for there to be only one `import Appboy-iOS-SDK` in the entire application. 

In doing do, this project demonstrates the abilities of how custom objects can be represented as Content Cards.

Objects can adopt the `ContentCardable` protocol which comes with the `ContentCardData` object and an initializer.
Upon receiving an array of `ABKContentCard` objects from the SDK, the corresponding `ABKContentCard` objects are converted into a `Dictionary` of metadata that are used to instantiate your custom objects.

This demo highlights 4 uses cases:
<ol>
  <li>Content Cards as Supplemental Content to an existing feed</li>
  <li>Content Cards that can be inserted/removed to/from an existing feed in real-time via silent push</li>
  <li>Content Cards as a Message Center</li>
  <li>Content Cards as an Interact-able View</li>
</ol>
Extra use cases:
<ol>
  <li>Content Cards as an Inline Ad Banner</li>
  <li>Content Cards that can be reordered in an existing feed in real-time via silent push</li>
</ol>
