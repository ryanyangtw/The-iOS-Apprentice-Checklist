//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Ryan on 2015/2/7.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import Foundation
import UIKit

class ChecklistItem: NSObject, NSCoding {
  var text = ""
  var checked = false
  var dueDate = NSDate()
  var shouldRemind = false
  var itemID: Int
  
  required init(coder aDecoder: NSCoder) {
    self.text = aDecoder.decodeObjectForKey("Text") as String
    self.checked = aDecoder.decodeBoolForKey("Checked")
    self.dueDate = aDecoder.decodeObjectForKey("DueDate") as NSDate
    self.shouldRemind = aDecoder.decodeBoolForKey("ShouldRemind")
    self.itemID = aDecoder.decodeIntegerForKey("ItemID")
    super.init()
  }
  
  init(text: String, checked: Bool) {
    self.text = text
    self.checked = checked
    self.itemID = DataModel.nextChecklistItemID()
    super.init()
  }
  
  convenience override init() {
    self.init(text: "", checked: false)
    //super.init()
  }
  
  // This method will be invoked when you delete an individual ChecklistItem but also when you delete a whole Checklir
  deinit {
    let existingNotification = notificationForThisItem()
    if let notification = existingNotification {
      //println("Removing existing notification \(notification)")
      UIApplication.sharedApplication().cancelLocalNotification(notification)
    }
  
  }
  

  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(self.text, forKey: "Text")
    aCoder.encodeBool(self.checked, forKey: "Checked")
    aCoder.encodeObject(self.dueDate, forKey: "DueDate")
    aCoder.encodeBool(self.shouldRemind, forKey: "ShouldRemind")
    aCoder.encodeInteger(self.itemID, forKey: "ItemID")
  }
  
  func toggleChecked() {
    self.checked = !self.checked
  }
  
  func scheduleNotification() {
    
    let existingNotification = notificationForThisItem()
    if let notification = existingNotification {
      //println("Found an existing notification \(notification)")
      UIApplication.sharedApplication().cancelLocalNotification(notification)
    }
  
    
    if shouldRemind && dueDate.compare(NSDate()) != NSComparisonResult.OrderedAscending {
      
      let localNotification = UILocalNotification()
      localNotification.fireDate = dueDate
      localNotification.timeZone = NSTimeZone.defaultTimeZone()
      localNotification.alertBody = self.text
      localNotification.soundName = UILocalNotificationDefaultSoundName
      localNotification.userInfo = ["ItemID": self.itemID]
      
      UIApplication.sharedApplication().scheduleLocalNotification( localNotification)
      
      
      //println("We should schedule a notification!")
    }
  }
  
  func notificationForThisItem() -> UILocalNotification? {
    let allNotifications = UIApplication.sharedApplication().scheduledLocalNotifications as [UILocalNotification]
    
    for notification in allNotifications {
      if let number = notification.userInfo?["ItemID"] as? NSNumber {
        if number.integerValue == itemID {
          return notification
        }
      }
    }
    
    return nil
  }

  
  
}
