import UIKit

protocol SliderActionDelegate: AnyObject {
  func sliderDidUpdate(newValue: Float, tag: Int)
}

class SliderConfigurationView: UIView {
  
  // MARK: - Outlets
  @IBOutlet private weak var titleLabel: UILabel!
  @IBOutlet private weak var valueLabel: UILabel!
  @IBOutlet private weak var slider: UISlider!
  
  // MARK: - Actions
  @IBAction func sliderDidDrag(_ sender: UISlider) {
    valueLabel.text = String(Int(sender.value))
  }
  
  @IBAction func sliderDidEndDrag(_ sender: UISlider) {
    valueLabel.text = String(Int(sender.value))
    
    delegate?.sliderDidUpdate(newValue: sender.value, tag: tag)
  }
  
  // MARK: - Variables
  weak var delegate: SliderActionDelegate?
}

// MARK: - Public
extension SliderConfigurationView {
  func configureView(_ title: String, value: Float = 0, minValue: Float = 0, maxValue: Float, tag: Int, delegate: SliderActionDelegate? = nil) {
    self.delegate = delegate
    self.tag = tag
    
    titleLabel.text = title + ":"
    valueLabel.text = String(Int(value))
    
    slider.minimumValue = minValue
    slider.maximumValue = maxValue
    slider.value = value
  }
}

