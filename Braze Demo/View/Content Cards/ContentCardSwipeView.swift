//
//  ContentCardSwipeView.swift
//  BookDemo
//
//  Created by Justin Malandruccolo on 7/29/20.
//  Copyright © 2020 Justin-Malandruccolo. All rights reserved.
//

import UIKit

protocol ViewEventDelegate: class {
  func viewDidAppear()
  func viewDidDismiss()
  func viewDidClick()
}

class ContentCardGestureView: UIView {
  
  // MARK: - Outlets
  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var swipeGesture: UISwipeGestureRecognizer!
  private weak var delegate: ViewEventDelegate?
  
  // MARK: - Actions
  @IBAction func viewDidSwipe(_ sender: Any) {
    dimiss()
  }
  @IBAction func buttonDidTap(_ sender: Any) {
    self.delegate?.viewDidClick()
  }
  
  func configureView(_ imageUrl: String?) {
    if let urlString = imageUrl, let url = URL(string: urlString) {
      ImageCache.sharedCache.image(from: url) { image in
        if let image = image {
          self.imageView.image = image
        }
      }
    }
  }
  
  func configureView(_ imageUrl: String?, _ origin: CGPoint, _ animatePoint: CGFloat, _ direction: UISwipeGestureRecognizer.Direction, _ delegate: ViewEventDelegate? = nil) {
    swipeGesture.direction = direction
    frame.origin = origin
    self.delegate = delegate
    
    configureView(imageUrl)
    
    UIView.animate(withDuration: 1.0, animations: {
      self.frame.origin.x = animatePoint
    }) { _ in
      self.delegate?.viewDidAppear()
    }
  }
}

// MARK: - Private Methods
private extension ContentCardGestureView {
  func dimiss() {
    UIView.animate(withDuration: 0.5, animations: {
      self.frame.origin.x = -self.frame.size.width
    }) { _ in
      self.delegate?.viewDidDismiss()
    }
  }
}

// MARK: - UIGestureRecognizerDelegate
extension ContentCardGestureView: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return touch.view is UIButton
  }
}

