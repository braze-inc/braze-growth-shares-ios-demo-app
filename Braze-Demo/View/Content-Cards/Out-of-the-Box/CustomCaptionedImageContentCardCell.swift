import AppboyUI

class CustomCaptionedImageContentCardCell: ABKCaptionedImageContentCardCell {
  
  override func apply(_ captionedImageCard: ABKCaptionedImageContentCard!) {
    super.apply(captionedImageCard)
    
    applyToBaseView(captionedImageCard)
    applyToCaptionedImageView(captionedImageCard)
  }
}
