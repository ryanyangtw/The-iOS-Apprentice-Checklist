//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Ryan on 2015/2/7.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {
  var text = ""
  var checked = false
  
  required init(coder aDecoder: NSCoder) {
    self.text = aDecoder.decodeObjectForKey("Text") as String
    self.checked = aDecoder.decodeBoolForKey("Checked")
    super.init()
  }
  
  init(text: String, checked: Bool) {
    self.text = text
    self.checked = checked
    super.init()
  }
  
  convenience override init() {
    self.init(text: "", checked: false)
    //super.init()
  }
  

  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(self.text, forKey: "Text")
    aCoder.encodeBool(self.checked, forKey: "Checked")
  }
  
  func toggleChecked() {
    self.checked = !self.checked
  }

  
  
}
