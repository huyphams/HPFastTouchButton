//
//  ViewController.swift
//  HPFastTouchButton
//
//  Created by Huy Pham on 2/14/15.
//  Copyright (c) 2015 CoreDump. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
  
  let cellIdent = "Cell"
  
  override func loadView() {
    
    super.loadView()
    let tableView = UITableView(frame: self.view.bounds)
    tableView.dataSource = self
    tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellIdent)
    tableView.backgroundColor = UIColor.lightGrayColor()
    self.view.addSubview(tableView)
    
    // HP's Fast touch button
    let fastTouchButton = HPFastTouchButton()
    fastTouchButton.addTarget(self, action: Selector("buttonTouched"), forControlEvents: UIControlEvents.TouchUpInside)
    fastTouchButton.addTarget(self, action: Selector("buttonToucheda"), forControlEvents: UIControlEvents.TouchUpInside)
    fastTouchButton.removeTarget(self, action: Selector("buttonToucheda"), forControlEvents: UIControlEvents.TouchUpInside)
    fastTouchButton.frame = CGRectMake(10, 100, 140, 140)
    fastTouchButton.titleLabel.text = "Fast touch button"
    
    let normalButton = UIButton()
    normalButton.addTarget(self, action: Selector("buttonTouched"), forControlEvents: UIControlEvents.TouchUpInside)
    normalButton.backgroundColor = UIColor.whiteColor()
    normalButton.frame = CGRectMake(170, 100, 140, 140)
    normalButton.setTitle("Normal button", forState: UIControlState.Normal)
    normalButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
    
    tableView.addSubview(fastTouchButton)
    tableView.addSubview(normalButton)
  }
  
  func buttonTouched() {
    
    let aler = UIAlertView(title: "You did it", message: "You touched on button",
      delegate: nil, cancelButtonTitle: "Ok")
    aler.show()
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return 50
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
    cell.textLabel?.text = "This is table view cell"
    cell.backgroundColor = UIColor.lightGrayColor()
    return cell
  }
}

