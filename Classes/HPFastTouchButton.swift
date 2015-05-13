//
//  HPFastTouchButton.swift
//  HPFastTouchButton
//
//  Created by Huy Pham on 2/14/15.
//  Copyright (c) 2015 CoreDump. All rights reserved.
//

import UIKit

private class Target {
  
  weak var target: AnyObject?
  var action: Selector!
  var event: UIControlEvents!
  
  func isEqual(target: Target?) -> Bool {
    
    if let targetToCompare = target {
      if let target1: AnyObject = self.target,
        target2: AnyObject = targetToCompare.target {
          if target1.isEqual(target2)
            && self.action == targetToCompare.action
            && self.event == targetToCompare.event {
              return true
          }
      }
    }
    return false
  }
  
  init(target: AnyObject?, action: Selector, event: UIControlEvents) {
    self.target = target
    self.action = action
    self.event = event
  }
}

private class ImageForState {
  
  var image: UIImage?
  var state = UIControlState.Normal
  
  init(image: UIImage?, state: UIControlState) {
    
    self.image = image
    self.state = state
  }
}

private class TitleForState {
  
  var string: String?
  var state = UIControlState.Normal
  
  init(string: String?, state: UIControlState) {
    
    self.string = string
    self.state = state
  }
}

private class TitleColorForState {
  
  var color: UIColor!
  var state = UIControlState.Normal
  
  init(color: UIColor, state: UIControlState) {
    
    self.color = color
    self.state = state
  }
}

class HPFastTouchButton: UIView {
  
  // Override super class properties
  override var frame : CGRect {
    
    didSet {
      
      self.relayoutContent()
    }
  }
  
  var selectedColor: UIColor = UIColor(red: 217.0/255.0,
    green: 217.0/255.0, blue: 217.0/255.0, alpha: 1.0)
  
  // Views
  // Private
  private let overlayView = UIView()
  private let imageView = UIImageView()
  
  // Public
  let titleLabel = UILabel()
  var selected: Bool = false {
    didSet {
      self.setNeedsDisplay()
    }
  }
  var toggle: Bool = false
  
  var imageMode: UIViewContentMode = UIViewContentMode.Center {
    didSet {
      self.imageView.contentMode = self.imageMode
    }
  }
  
  var titleInsets: UIEdgeInsets = UIEdgeInsetsZero {
    didSet {
      self.relayoutContent()
    }
  }
  
  var imageInsets: UIEdgeInsets = UIEdgeInsetsZero {
    didSet {
      self.relayoutContent()
    }
  }
  
  var enable: Bool = true {
    didSet {
      self.userInteractionEnabled = self.enable
    }
  }
  
  // Class properties
  private var imagesForState: [ImageForState] = [] {
    didSet {
      self.setNeedsDisplay()
    }
  }
  private var titlesForState: [TitleForState] = [] {
    didSet {
      self.setNeedsDisplay()
    }
  }
  private var titleColorsForState: [TitleColorForState] = [] {
    didSet {
      self.setNeedsDisplay()
    }
  }
  
  private var targets: [Target] = []
  private var currentState = UIControlState.Normal
  
  private var cancelEvent: Bool = false
  
  // Custom init.
  required init(coder aDecoder: NSCoder) {
    
    super.init(coder: aDecoder)
  }
  
  init() {
    
    super.init(frame: CGRectZero)
    self.commonInit()
  }
  
  func commonInit() {
    
    self.backgroundColor = UIColor.clearColor()
    self.initView()
  }
  
  func initView() {
    
    self.imageView.backgroundColor = UIColor.clearColor()
    self.imageView.userInteractionEnabled = false
    self.imageView.contentMode = UIViewContentMode.Center
    
    self.overlayView.backgroundColor = UIColor.clearColor()
    self.overlayView.userInteractionEnabled =  false
    
    self.titleLabel.backgroundColor = UIColor.clearColor()
    self.titleLabel.textAlignment = NSTextAlignment.Center
    
    self.addSubview(self.imageView)
    self.addSubview(self.overlayView)
    self.addSubview(self.titleLabel)
  }
  
  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    
    self.cancelEvent = false
    self.currentState = UIControlState.Highlighted
    self.setNeedsDisplay()
  }
  
  override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
    
    self.cancelEvent = true
    self.currentState = UIControlState.Normal
    self.setNeedsDisplay()
    if let nextResponder = self.nextResponder() {
      nextResponder.touchesMoved(touches as Set<NSObject>, withEvent: event)
    }
  }
  
  override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
    
    self.currentState = UIControlState.Normal
    self.setNeedsDisplay()
    
    if self.cancelEvent {
      if let nextResponder = self.nextResponder() {
        nextResponder.touchesEnded(touches as Set<NSObject>, withEvent: event)
      }
    } else {
      self.triggerSelector()
    }
    self.cancelEvent = false
  }
  
  override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
    
    self.currentState = UIControlState.Normal
    self.setNeedsDisplay()
    if let nextResponder = self.nextResponder() {
      nextResponder.touchesCancelled(touches, withEvent: event)
    }
    self.cancelEvent = false
  }
  
  private func triggerSelector() {
    
    if self.toggle {
      self.selected = !self.selected
    }
    for target in targets {
      if let object: AnyObject = target.target {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
          NSThread.detachNewThreadSelector(target.action, toTarget: object, withObject: self)
        })
      }
    }
  }
  
  private func imageForState(state: UIControlState) -> UIImage? {
    
    var normalImage: UIImage?
    for imageForState in self.imagesForState {
      if imageForState.state == state {
        return imageForState.image
      } else if imageForState.state == UIControlState.Normal {
        normalImage = imageForState.image
      }
    }
    return normalImage
  }
  
  private func titleForState(state: UIControlState) -> String? {
    
    var normalTitle: String?
    for titleForState in self.titlesForState {
      if titleForState.state == state {
        return titleForState.string
      } else if titleForState.state == UIControlState.Normal {
        normalTitle = titleForState.string
      }
    }
    return normalTitle
  }
  
  private func titleColorForState(state: UIControlState) -> UIColor? {
    
    var normalColor: UIColor?
    for titleColorForState in self.titleColorsForState {
      if titleColorForState.state == state {
        return titleColorForState.color
      } else if titleColorForState.state == UIControlState.Normal {
        normalColor = titleColorForState.color
      }
    }
    return normalColor
  }
  
  private func addImageForState(imageForState: ImageForState) {
    
    for (index, imageForStateElement) in enumerate(imagesForState) {
      if imageForStateElement.state == imageForState.state {
        self.imagesForState.removeAtIndex(index)
      }
    }
    self.imagesForState.append(imageForState)
  }
  
  private func addTitleForState(titleForState: TitleForState) {
    
    for (index, titleForStateElement) in enumerate(titlesForState) {
      if titleForStateElement.state == titleForState.state {
        self.titlesForState.removeAtIndex(index)
      }
    }
    self.titlesForState.append(titleForState)
  }
  
  private func addTitleColorForState(titleColorForState: TitleColorForState) {
    
    for (index, titleColorForStateElement) in enumerate(titleColorsForState) {
      if titleColorForStateElement.state == titleColorForState.state {
        self.titleColorsForState.removeAtIndex(index)
      }
    }
    self.titleColorsForState.append(titleColorForState)
  }
  
  func addTarget(target: AnyObject?, action: Selector,
    forControlEvents controlEvents: UIControlEvents) {
      
      let newTarget = Target(target: target,
        action: action, event: controlEvents)
      for targetElement in targets {
        if newTarget.isEqual(targetElement) {
          return
        }
      }
      targets.append(newTarget)
  }
  
  func removeTarget(target: AnyObject?, action: Selector,
    forControlEvents controlEvents: UIControlEvents) {
      
      let newTarget = Target(target: target,
        action: action, event: controlEvents)
      for (index, targetElement) in enumerate(targets) {
        if newTarget.isEqual(targetElement) {
          targets.removeAtIndex(index)
        }
      }
  }
  
  func setImage(image: UIImage?, forState state: UIControlState) {
    
    let imageForState = ImageForState(image: image, state: state)
    self.addImageForState(imageForState)
  }
  
  
  func setTitle(title: String?, forState state: UIControlState) {
    
    let titleForState = TitleForState(string: title, state: state)
    self.addTitleForState(titleForState)
  }
  
  func setTitleColor(color: UIColor?, forState state: UIControlState) {
    
    if let colorWrapping = color {
      let titleColorForState = TitleColorForState(color: colorWrapping, state: state)
      self.addTitleColorForState(titleColorForState)
    }
  }
  
  private func relayoutContent() {
    
    // Change views frame
    self.imageView.frame = CGRectMake(self.imageInsets.left,
      self.imageInsets.top,
      CGRectGetWidth(self.bounds) - self.imageInsets.left - self.imageInsets.right,
      CGRectGetHeight(self.bounds) - self.imageInsets.top - self.imageInsets.bottom)
    
    self.overlayView.frame = self.bounds
    self.titleLabel.frame = CGRectMake(self.titleInsets.left,
      self.imageInsets.top,
      CGRectGetWidth(self.bounds) - self.titleInsets.left - self.titleInsets.right,
      CGRectGetHeight(self.bounds) - self.titleInsets.top - self.titleInsets.bottom)
  }
  
  override func drawRect(rect: CGRect) {
    
    super.drawRect(rect)
    
    // Change background color.
    if self.selected {
      self.overlayView.backgroundColor = self.selectedColor
    } else {
      switch self.currentState {
      case UIControlState.Normal:
        self.overlayView.backgroundColor = UIColor.clearColor()
        break
      case UIControlState.Highlighted:
        self.overlayView.backgroundColor = self.selectedColor
        break
      default:
        self.overlayView.backgroundColor = UIColor.clearColor()
      }
    }
    
    // Change image for state.
    if  self.selected {
      
      if let image = self.imageForState(UIControlState.Selected) {
        self.imageView.image = image
      } else {
        self.imageView.image = self.imageForState(self.currentState)
      }
      
      if let title = self.titleForState(UIControlState.Selected) {
        self.titleLabel.text = title
      } else {
        self.titleLabel.text = self.titleForState(self.currentState)
      }
      
      if let titleColor = self.titleColorForState(UIControlState.Selected) {
        self.titleLabel.textColor = titleColor
      } else {
        if let titleColor = self.titleColorForState(self.currentState) {
          self.titleLabel.textColor = titleColor
        } else {
          self.titleLabel.textColor = UIColor.blackColor()
        }
      }
    } else {
      self.imageView.image = self.imageForState(self.currentState)
      self.titleLabel.text = self.titleForState(self.currentState)
      if let titleColor = self.titleColorForState(self.currentState) {
        self.titleLabel.textColor = titleColor
      } else {
        self.titleLabel.textColor = UIColor.blackColor()
      }
    }
    
    // Set overlay alpha.
    if let image = self.imageView.image {
      self.overlayView.alpha = 0.6
    } else {
      self.overlayView.alpha = 1.0
    }
  }
}
