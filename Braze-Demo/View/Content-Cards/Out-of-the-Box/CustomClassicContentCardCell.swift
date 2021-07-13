import AppboyUI

class CustomClassicContentCardCell: ABKClassicContentCardCell {
  
  override func apply(_ classicCard: ABKClassicContentCard!) {
    super.apply(classicCard)
    
    applyToBaseView(classicCard)
    applyToClassicView(classicCard)
  }
}
