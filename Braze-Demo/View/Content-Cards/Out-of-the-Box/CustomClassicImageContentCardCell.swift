import AppboyUI

class CustomClassicImageContentCardCell: ABKClassicImageContentCardCell {
  
  override func apply(_ classicCard: ABKClassicContentCard!) {
    super.apply(classicCard)
    
    applyToBaseView(classicCard)
    applyToClassicView(classicCard)
  }
}
