//
//  ViewController.swift
//  Checklists
//
//  Created by Ryan on 2015/2/5.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
  
  var checklist: Checklist!
  var items: [ChecklistItem]
  
  required init(coder aDecoder: NSCoder) {
    
    // [ChecklistItem]: means an array of ChecklistItem objects
    // (): tell Swift to make the new array object
    items = [ChecklistItem]()
    
    /*
    let row0item = ChecklistItem()
    row0item.text = "Walk the Dog"
    row0item.checked = false
    items.append(row0item)
    */
    
    super.init(coder: aDecoder)
    
    loadChecklistItems()
    
    //println("Documents folder is \(documentsDirecoty())" )
    //println("Data file path is \(dataFilePath())")
    
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.rowHeight = 44;
    self.title = checklist.name
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
// MARK: - Data Source
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //println("In numberOfRowsInSection ")
    return self.items.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    //println("In cellForRowAtIndexPath ")
    
    let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem") as UITableViewCell
    
    
    let item = self.items[indexPath.row]
    
    configureTextForCell(cell, withChecklistItem: item)
    configureCheckmarkForCell(cell, withChecklistItem: item)
    
    return cell
  
  }
  
  // Delete list
  override func tableView(tableView: UITableView, commitEditingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
  
    // 1. Remove the item form data model
    self.items.removeAtIndex(indexPath.row)
    
    // 2. deleete the corrspondoing row from talbe view
    let indexPaths = [indexPath]
    tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    saveChecklistItems()
  }
  
  
// MARK: - TableView Delegate
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
    
    // The mehod cellForRowAtIndexPath(indecPath) is different with the above method in Data source
    if let cell = tableView.cellForRowAtIndexPath(indexPath) {

      let item = self.items[indexPath.row]
      item.toggleChecked()
 
      configureCheckmarkForCell(cell, withChecklistItem: item)

    }
  
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    saveChecklistItems()
  }
 
// MARK: - ItemDetailViewController Delegate
  
  func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
    // Telling to the "presinting view controller" to close the screen with an animation
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
    
    
    let newRowIndex = items.count
    
    items.append(item)
    
    let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
    let indexPaths = [indexPath]
    tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    
    dismissViewControllerAnimated(true, completion: nil)
    saveChecklistItems()
  }
  
  func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
    
    println("in didFinishEditingItem")
    // "equatiable".find , ChecklistItem should be a equatible object
    //  NSObject is equatable
    if let index = find(items, item) {
      let indexPath = NSIndexPath(forRow: index, inSection: 0)
      if let cell = tableView.cellForRowAtIndexPath(indexPath) {
        configureTextForCell(cell, withChecklistItem: item)
      }
    }

    dismissViewControllerAnimated(true, completion: nil)
    saveChecklistItems()
  
  }
  
  
  
  
  
  
// MARK: - Instance Methosd
  
  func configureCheckmarkForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
    
    let label = cell.viewWithTag(1001) as UILabel
    
    if item.checked {
      //cell.accessoryType = .Checkmark
      label.text = "√"
    } else {
      //cell.accessoryType = .None
      label.text = ""
    }
  }
  
  func configureTextForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
    // It's a property in UIView. Get the subview which matches the value(10000) in the tag parameter.
    let label = cell.viewWithTag(1000) as UILabel
    label.text = item.text
  }
  

  
// MARK: - Prepare For Segue
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if segue.identifier == "AddItem" {
      let navigationController = segue.destinationViewController as UINavigationController
      let controller = navigationController.topViewController as ItemDetailViewController
      
      controller.delegate = self
    } else if segue.identifier == "EditItem" {
      let navigationController = segue.destinationViewController as UINavigationController
      let controller = navigationController.topViewController as ItemDetailViewController
      
      controller.delegate = self

      // Unwrap the NSIndexPath? from tableView.indexPathForCell
      if let indexPath = tableView.indexPathForCell(sender as UITableViewCell) {
        controller.itemToEdit = items[indexPath.row]
      }
    
    }
  }
  
// MARK: - Documents
  
  func documentsDirecoty() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String]
    return paths[0]
  }
  
  // Get the full path to the Documents folder
  func dataFilePath() -> String {
    let directory = documentsDirecoty()
    return directory.stringByAppendingPathComponent("Checklists.plist")
    //return documentsDirecoty().stringByAppendingPathComponent("Checklists.plist")
  }
  
  func saveChecklistItems() {
    let data = NSMutableData()
    let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
    //ChecklistItem should implement NSCoding protocol
    archiver.encodeObject(self.items, forKey: "ChecklistItems")
    archiver.finishEncoding()
    data.writeToFile(dataFilePath(), atomically: true)
  }
  
  func loadChecklistItems() {
    // use local variable to record the path
    let path = dataFilePath()
    
    // Check file actually exists
    if NSFileManager.defaultManager().fileExistsAtPath(path) {
      // Load Data
      if let data = NSData(contentsOfFile: path) {
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
        items = unarchiver.decodeObjectForKey("ChecklistItems") as [ChecklistItem]
        
        unarchiver.finishDecoding()
      }
    }
  }

  
  
  
}

