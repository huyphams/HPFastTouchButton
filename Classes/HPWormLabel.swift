//
//  WormLabel.swift
//  Bubu
//
//  Created by Huy Pham on 2/12/15.
//  Copyright (c) 2015 LOZI. All rights reserved.
//

import UIKit

private enum SectionType {
  case String
  case Image
}

private class Section {
  
  var content: String?
  var font: UIFont!
  var color: UIColor = UIColor.blackColor()
  var alignment = NSTextAlignment.Left
  var image: UIImage?
  var scale: CGFloat!
  var type: SectionType
  
  init(content: String?, font: UIFont, color: UIColor,
    alignment: NSTextAlignment?) {
      self.content = content
      self.font = font
      self.color = color
      if let unwrappingAlignment = alignment {
        self.alignment = unwrappingAlignment
      }
      self.type = SectionType.String
  }
  
  init(image: UIImage?, scale: CGFloat) {
    self.image = image
    self.scale = scale
    self.type = SectionType.Image
  }
}

class HPWormLabel: UILabel {
  
  private var sections: [Section] = [] {
    didSet {
      self.renderLabel()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  init() {
    super.init(frame: CGRectZero)
    self.commonInit()
  }
  
  private func renderUI(block: dispatch_block_t) {
    if NSThread.isMainThread() {
      block()
    } else {
      dispatch_async(dispatch_get_main_queue(), block)
    }
  }
  
  private func commonInit() {
    self.frame = CGRectZero
    self.backgroundColor = UIColor.clearColor()
    self.userInteractionEnabled = false
    self.text = nil
  }
  
  private func getStringAttribute(section: Section) -> NSAttributedString {
    let paragraph = NSMutableParagraphStyle()
    switch section.type {
    case .String:
      paragraph.alignment = section.alignment
      let attribute = [NSFontAttributeName: section.font ,
        NSForegroundColorAttributeName: section.color, NSParagraphStyleAttributeName: paragraph]
      let attributeString = NSAttributedString(string: section.content!, attributes: attribute)
      return attributeString
      
    case .Image:
      let textAttachment = NSTextAttachment()
      textAttachment.image = section.image
      let attributeString = NSAttributedString(attachment: textAttachment)
      return attributeString
    }
  }
  
  func renderLabel() {
    if self.sections.count > 0 {
      let attributeString  = NSMutableAttributedString()
      for section in self.sections {
        attributeString.appendAttributedString(self.getStringAttribute(section))
      }
      self.attributedText = attributeString
    }
  }
  
  func addStringSection(font: UIFont, color: UIColor,
    string: String?, alignment: NSTextAlignment?) {
      let section = Section(content: string,
        font: font, color: color, alignment: alignment)
      self.sections.append(section)
  }
  
  func addImageSection(image: UIImage?, scale: CGFloat) {
    let section = Section(image: image, scale: scale)
    self.sections.append(section)
  }
  
  func removeAllStringSection() {
    self.text = nil
    self.sections.removeAll(keepCapacity: false)
  }
}
