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

  init(name: String) {
    self.name = name
    super.init()
  }
  
  
// NSCoding protocol
  
  required init(coder aDecoder: NSCoder) {
    self.name = aDecoder.decodeObjectForKey("Name") as String
    self.items = aDecoder.decodeObjectForKey("Items") as [ChecklistItem]
    super.init()
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(self.name, forKey: "Name")
    aCoder.encodeObject(self.items, forKey: "Items")
  }
  
  
  
}
