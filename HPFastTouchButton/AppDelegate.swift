//
//  AppDelegate.swift
//  HPFastTouchButton
//
//  Created by Huy Pham on 2/14/15.
//  Copyright (c) 2015 CoreDump. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  func application(application: UIApplication, didFinishLaunchingWithOptions
    launchOptions: [NSObject: AnyObject]?) -> Bool {
      
      let viewController = ViewController()
      self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
      if let window = self.window {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
      }
      return true
  }
}

