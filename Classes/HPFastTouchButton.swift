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
  var action: Selector = Selector("")
  var event: UIControlEvents = UIControlEvents.TouchUpInside
}

class HPFastTouchButton: UIView {
  
  // Override super class properties
  override var frame : CGRect {
    didSet {
      self.overlayView.frame = self.bounds
      self.titleLabel.frame = self.bounds
    }
  }
  
  var selectedColor: UIColor = UIColor.lightGrayColor()
  
  // Views
  // Private
  private let overlayView = UIView()
  
  // Public
  let titleLabel = UILabel()
  
  // Class properties
  private var targets: [Target] = []
  
  
  // Custom init.
  required init(coder aDecoder: NSCoder) {
    
    super.init(coder: aDecoder)
  }
  
  override init() {
    
    super.init(frame: CGRectZero)
    commonInit()
  }
  
  func commonInit() {
    
    self.backgroundColor = UIColor.whiteColor()
    self.initView()
  }
  
  func initView() {
    
    self.overlayView.backgroundColor = UIColor.clearColor()
    self.overlayView.userInteractionEnabled =  false
    
    self.titleLabel.backgroundColor = UIColor.clearColor()
    
    self.addSubview(self.overlayView)
    self.addSubview(self.titleLabel)
  }
  
  override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    
    self.overlayView.backgroundColor = self.selectedColor
    if let nextResponder = self.nextResponder() {
      nextResponder.touchesBegan(touches, withEvent: event)
    }
  }
  
  override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
    
    self.overlayView.backgroundColor = UIColor.clearColor()
    if let nextResponder = self.nextResponder() {
      nextResponder.touchesMoved(touches, withEvent: event)
    }
  }
  
  override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
    
    self.overlayView.backgroundColor = UIColor.clearColor()
    self.triggerSelector()
    if let nextResponder = self.nextResponder() {
      nextResponder.touchesEnded(touches, withEvent: event)
    }
  }
  
  private func compareTarget(target1: Target, target2: Target) -> Bool {
    
    if let targetObject1: AnyObject = target1.target {
      if let targetObject2: AnyObject = target2.target {
        if targetObject1.isEqual(targetObject2) {
          if target1.action == target2.action && target1.event == target2.event {
            return true
          }
        }
      }
    }
    return false
  }
  
  private func triggerSelector() {
    
    for target in targets {
      if let object: AnyObject = target.target {
        let delay = 10
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
          NSThread.detachNewThreadSelector(target.action, toTarget: object, withObject: object)
        })
      }
    }
  }
  
  func addTarget(target: AnyObject?, action: Selector,
    forControlEvents controlEvents: UIControlEvents) {
      
      let newTarget = Target()
      newTarget.target = target
      newTarget.action = action
      newTarget.event = controlEvents
      
      for targetElement in targets {
        if compareTarget(newTarget, target2: targetElement) {
          return
        }
      }
      targets.append(newTarget)
  }
  
  func removeTarget(target: AnyObject?, action: Selector,
    forControlEvents controlEvents: UIControlEvents) {
      
      let newTarget = Target()
      newTarget.target = target
      newTarget.action = action
      newTarget.event = controlEvents
      
      for (index, targetElement) in enumerate(targets) {
        if compareTarget(newTarget, target2: targetElement) {
          targets.removeAtIndex(index)
        }
      }
      
  }

  
  func setTitle(title: String?, forState state: UIControlState) {
    
    NSLog("Not supported (Comming soon)... I'm a lazy boy, I need food, I love food, I love milk carrot, it's delicious... ;_;")
  }
}
