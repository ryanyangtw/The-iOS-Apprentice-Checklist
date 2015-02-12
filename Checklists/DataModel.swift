//
//  DataModel.swift
//  Checklists
//
//  Created by Ryan on 2015/2/10.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import Foundation

// DataModel takes over the responsibilities for loading and saving the to-do lists from AllListViewController
class DataModel {
  var lists = [Checklist]()
  
  // Computed property
  var indexOfSelectedChecklist: Int {
    get {
      return NSUserDefaults.standardUserDefaults().integerForKey("ChecklistIndex")
    }
    set {
      NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "ChecklistIndex")
    }
  
  }
  
  
  init() {
    println("\(documentsDirectory())")
    
    //println("In dataModel init")
    loadChecklists()
    registerDefaults()
    handleFirstTime()
  }
  

  func registerDefaults() {
    let dictionary = ["ChecklistIndex": -1, "FirstTime": true, "ChecklistItemID" : 0]
    // registerDefaults: 當key,value不存在時寫入，若已存在則不覆蓋
    NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
 
  }
  
  func handleFirstTime() {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let firstTime = userDefaults.boolForKey("FirstTime")
    if firstTime {
      let checklist = Checklist(name: "List", iconName: "Folder")
      //checklist.iconName = "Folder"
      self.lists.append(checklist)
      self.indexOfSelectedChecklist = 0
      userDefaults.setBool(false, forKey: "FirstTime")
    }
  }
  
  func sortChecklists() {
    self.lists.sort({ checklist1, checklist2 in return checklist1.name.localizedStandardCompare(checklist2.name) ==  NSComparisonResult.OrderedAscending })
  }
  
  
// MARK: - Class Method
  
  class func nextChecklistItemID() -> Int {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let itemID = userDefaults.integerForKey("ChecklistItemID")
    
    userDefaults.setInteger(itemID + 1, forKey: "ChecklistItemID")
    
    // Force NSUserDefaults to write these chenage immediately
    userDefaults.synchronize()
    
    return itemID
  
  }
  
  
  
  
// MARK: - Documents
  
  func documentsDirectory() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String]
    
    return paths[0]
  }
  
  func dataFilePath() -> String {
    return documentsDirectory().stringByAppendingPathComponent("Checklists.plist")
  }
  
  func saveChecklists() {
    let data = NSMutableData()
    let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
    archiver.encodeObject(self.lists, forKey: "Checklists")
    archiver.finishEncoding()
    data.writeToFile(dataFilePath(), atomically: true)
  }
  
  func loadChecklists() {
    let path = dataFilePath()
    if NSFileManager.defaultManager().fileExistsAtPath(path) {
      if let data = NSData(contentsOfFile: path) {
        
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
        self.lists = unarchiver.decodeObjectForKey("Checklists") as [Checklist]
        unarchiver.finishDecoding()
      }
    }
    
    sortChecklists()
  }
}
