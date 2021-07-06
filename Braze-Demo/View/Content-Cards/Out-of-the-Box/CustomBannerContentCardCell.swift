import AppboyUI

class CustomBannerContentCardCell: ABKBannerContentCardCell {
  
  override func apply(_ bannerCard: ABKBannerContentCard!) {
    super.apply(bannerCard)
    
    applyToBaseView(bannerCard)
  }
}
