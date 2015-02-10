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
  
  
  init() {
    loadChecklists()
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
  }
}
