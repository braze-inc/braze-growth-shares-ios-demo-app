import AppboyUI

// MARK: - ABK Base
extension ABKBaseContentCardCell {
  func applyToBaseView(_ card: ABKContentCard) {
    if let backgroundColor = card.extras?[ContentCardKey.backgroundColor.rawValue] as? String,
       let backgroundColorValue = backgroundColor.colorValue() {
      rootView.backgroundColor = backgroundColorValue
    } else {
      rootView.backgroundColor = BrazeBackgroundColor
    }
    
    if let borderColor = card.extras?[ContentCardKey.borderColor.rawValue] as? String,
       let borderColorValue = borderColor.colorValue() {
      rootView.layer.borderColor = borderColorValue.cgColor
    } else {
      rootView.layer.borderColor = BrazeBorderColor.cgColor
    }
    
    if let cornerRadiusString = card.extras?[ContentCardKey.cornerRadius.rawValue] as? String,
       let cornerRadius = Float(cornerRadiusString) {
      rootView.layer.cornerRadius = CGFloat(cornerRadius)
    } else {
      rootView.layer.cornerRadius = BrazeCornerRadius
    }
    
    if let borderWidthString = card.extras?[ContentCardKey.borderWidth.rawValue] as? String,
       let borderWidth = Float(borderWidthString) {
      rootView.layer.borderWidth = CGFloat(borderWidth)
    } else {
      rootView.layer.borderWidth = BrazeBorderWidth
    }
    
    if let unreadColor = card.extras?[ContentCardKey.unreadColor.rawValue] as? String,
       let unreadColorValue = unreadColor.colorValue() {
      unviewedLineViewColor = unreadColorValue
    } else {
      unviewedLineViewColor = BrazeUnreadColor
    }
  }
}

// MARK: - ABK Classic
extension ABKClassicContentCardCell {
  
  func applyToClassicView(_ card: ABKContentCard) {
    if let labelColor = card.extras?[ContentCardKey.labelColor.rawValue] as? String,
       let labelColorValue = labelColor.colorValue() {
      titleLabel.textColor = labelColorValue
      descriptionLabel.textColor = labelColorValue
    } else {
      titleLabel.textColor = BrazeLabelColor
      descriptionLabel.textColor = BrazeLabelColor
    }
    
    if let linkColor = card.extras?[ContentCardKey.linkColor.rawValue] as? String,
       let linkColorValue = linkColor.colorValue() {
      linkLabel.textColor = linkColorValue
    } else {
      linkLabel.textColor = BrazeLinkColor
    }
    
    if let fontName = card.extras?[ContentCardKey.fontStyle.rawValue] as? String,
       !fontName.isEmpty {
      titleLabel.font = UIFont(name: "Sailec-Bold", size: titleLabel.font.pointSize)
      descriptionLabel.font = UIFont(name: "Sailec-Regular", size: descriptionLabel.font.pointSize)
      linkLabel.font = UIFont(name: "Sailec-Medium", size: linkLabel.font.pointSize)
    } else {
      titleLabel.font = ABKUIUtils.preferredFont(forTextStyle: .callout, weight: .bold)
      descriptionLabel.font = ABKUIUtils.preferredFont(forTextStyle: .footnote, weight: .regular)
      linkLabel.font = ABKUIUtils.preferredFont(forTextStyle: .footnote, weight: .medium)
    }
  }
}

// MARK: - ABK Captioned Image
extension ABKCaptionedImageContentCardCell {
  
  func applyToCaptionedImageView(_ card: ABKContentCard) {
    if let labelColor = card.extras?[ContentCardKey.labelColor.rawValue] as? String,
       let labelColorValue = labelColor.colorValue() {
      titleLabel.textColor = labelColorValue
      descriptionLabel.textColor = labelColorValue
    } else {
      titleLabel.textColor = BrazeLabelColor
      descriptionLabel.textColor = BrazeLabelColor
    }
    
    if let linkColor = card.extras?[ContentCardKey.linkColor.rawValue] as? String,
       let linkColorValue = linkColor.colorValue() {
      linkLabel.textColor = linkColorValue
    } else {
      linkLabel.textColor = BrazeLinkColor
    }
    
    if let fontName = card.extras?[ContentCardKey.fontStyle.rawValue] as? String,
       !fontName.isEmpty {
      titleLabel.font = UIFont(name: "Sailec-Bold", size: titleLabel.font.pointSize)
      descriptionLabel.font = UIFont(name: "Sailec-Regular", size: descriptionLabel.font.pointSize)
      linkLabel.font = UIFont(name: "Sailec-Medium", size: linkLabel.font.pointSize)
    } else {
      titleLabel.font = ABKUIUtils.preferredFont(forTextStyle: .callout, weight: .bold)
      descriptionLabel.font = ABKUIUtils.preferredFont(forTextStyle: .footnote, weight: .regular)
      linkLabel.font = ABKUIUtils.preferredFont(forTextStyle: .footnote, weight: .medium)
    }
  }
}

// MARK: Default UI
fileprivate extension ABKBaseContentCardCell {
  var BrazeCornerRadius: CGFloat {
    return 3
  }
  var BrazeBorderWidth: CGFloat {
    return 0
  }
  
  var BrazeBackgroundColor: UIColor {
    return .systemBackground
  }

  var BrazeLabelColor: UIColor {
    return .label
  }
  
  var BrazeLinkColor: UIColor {
    return .link
  }
  
  var BrazeUnreadColor: UIColor {
    return self.tintColor
  }
  
  var BrazeBorderColor: UIColor {
    return .black
  }
}
