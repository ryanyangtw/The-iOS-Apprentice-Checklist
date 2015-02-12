//
//  Checklist.swift
//  Checklists
//
//  Created by Ryan on 2015/2/9.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
  
  var name = ""
  // var items: [ChecklistItem] = [ChecklistItem]()
  var items = [ChecklistItem]()
  var iconName: String

  convenience init(name: String) {
    self.init(name: name, iconName: "No Icon")
  }
  
  init(name: String, iconName: String) {
    self.name = name
    self.iconName = iconName
    super.init()
  }
  
  func countUncheckedItems() -> Int {
    var count = 0
    for item in self.items {
      if !item.checked {
        count += 1
      }
    }
    return count
  }
  
  
// NSCoding protocol
  
  required init(coder aDecoder: NSCoder) {
    self.name = aDecoder.decodeObjectForKey("Name") as String
    self.items = aDecoder.decodeObjectForKey("Items") as [ChecklistItem]
    self.iconName = aDecoder.decodeObjectForKey("IconName") as String
    super.init()
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(self.name, forKey: "Name")
    aCoder.encodeObject(self.items, forKey: "Items")
    aCoder.encodeObject(self.iconName, forKey: "IconName")
  }
  
  
  
}
