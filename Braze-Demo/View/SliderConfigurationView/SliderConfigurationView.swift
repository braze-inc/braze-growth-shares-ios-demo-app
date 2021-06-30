import UIKit

class SliderConfigurationView: UIView {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var slider: UISlider!
  
  func configureView(_ title: String?, minValue: Float = 0, maxValue: Float, intervalValue: Int = 1) {
    titleLabel.text = title
    
    slider.minimumValue = minValue
    slider.maximumValue = maxValue
    slider.value = 0
  }
}
