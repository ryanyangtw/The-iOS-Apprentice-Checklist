//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Ryan on 2015/2/7.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import Foundation

class ChecklistItem {
  var text = ""
  var checked = false
  
  
  func toggleChecked() {
    self.checked = !self.checked
  }
  
  
}
