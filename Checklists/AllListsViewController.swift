//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Ryan on 2015/2/9.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate {
  
  // var lists: Array<Checklist>
  var lists: [Checklist]
  
  required init(coder aDecoder: NSCoder) {
    // lists = Array<Checklist>()
    lists = [Checklist]()
    
    // 2
    super.init(coder: aDecoder)
    
    // 3
    var list = Checklist(name: "Birthday")
    lists.append(list)
    
    list = Checklist(name: "Groceries")
    lists.append(list)
    
    list = Checklist(name: "Cook Apps")
    lists.append(list)
    
    list = Checklist(name: "To Do")
    lists.append(list)
  }



// MARK: - Table view data source


  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.lists.count
  }


  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cellIdentifier = "Cell"
    
    var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
    
    
    if cell == nil {
      cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
    }
    
    //cell.textLabel!.text = "List \(indexPath.row)"
    
    let checklist = lists[indexPath.row]
    cell.textLabel!.text = checklist.name
    cell.accessoryType = .DetailDisclosureButton

    return cell
  }
  
  
  // Delete Checklist
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    lists.removeAtIndex(indexPath.row)
    
    let indexPaths = [indexPath]
    tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
  }

// MARK: - Table View Delegate

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    let checklist = lists[indexPath.row]
    
    // Manually execuate prepareForSegue
    performSegueWithIdentifier("ShowChecklist", sender: checklist) // Putting checklist as sender

  }
  
  override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
    
    // Create the new controller (ListNavigationController)
    let navigationController = storyboard!.instantiateViewControllerWithIdentifier("ListNavigationController") as UINavigationController
    
    let controller = navigationController.topViewController as ListDetailViewController
    
    controller.delegate = self
    let checklist = lists[indexPath.row]
    
    controller.checklistToEdit = checklist
    
    presentViewController(navigationController, animated: true, completion: nil)
    
  }
  
  
    
// MARK: - Navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if segue.identifier == "ShowChecklist" {
      
      //let navigationController = segue.destinationViewController as UINavigationController
      //let controller = navigationController.topViewController as ListDetailViewController
      let controller = segue.destinationViewController as ChecklistViewController
      controller.checklist = sender as Checklist
    } else if segue.identifier == "AddChecklist" {
      let navigationController = segue.destinationViewController as UINavigationController
      
      let controller = navigationController.topViewController as ListDetailViewController
      
      controller.delegate = self
      controller.checklistToEdit = nil
    
    }
  }
  
// MARK: ListDetailViewControllerDelegate Delegate
  
  func listDetailViewControllerDidCancel(controller: ListDetailViewController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func listDetailViewController(controller: ListDetailViewController, didFinishAddingChecklist checklist: Checklist) {
    
    let newRowIndex = lists.count
    self.lists.append(checklist)
    
    let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
    let indexPaths = [indexPath]
    self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func listDetailViewController(controller: ListDetailViewController, didFinishEditingChecklist checklist: Checklist) {
    
    if let index = find(lists, checklist) {
      let indexPath = NSIndexPath(forRow: index, inSection: 0)
      if let cell = tableView.cellForRowAtIndexPath(indexPath) {
        cell.textLabel!.text = checklist.name
      }
    }
    
    dismissViewControllerAnimated(true, completion: nil)
  
  }
  



}
