//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Ryan on 2015/2/9.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
  
  // var lists: Array<Checklist>
  //var lists: [Checklist]
  var dataModel: DataModel!
  
// MARK: - Controller life cycle
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    println("In AllListsViewController init")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    println("In ViewDidLoad")
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    navigationController?.delegate = self
    
    println("In ViewDidAppear")
    
    let index = self.dataModel.indexOfSelectedChecklist
    println("Index: \(index)")
    if index >= 0 && index < dataModel.lists.count {
      let checklist = dataModel.lists[index]
      performSegueWithIdentifier("ShowChecklist", sender: checklist)
    }
  
  }
  
// MARK: - Table view data source

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.dataModel.lists.count
  }


  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cellIdentifier = "Cell"
    
    var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
    
    
    if cell == nil {
      cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
    }
    
    //cell.textLabel!.text = "List \(indexPath.row)"
    
    let checklist = self.dataModel.lists[indexPath.row]
    cell.textLabel!.text = checklist.name
    cell.accessoryType = .DetailDisclosureButton

    return cell
  }
  
  
  // Delete Checklist
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    self.dataModel.lists.removeAtIndex(indexPath.row)
    
    let indexPaths = [indexPath]
    tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
  }

// MARK: - Table View Delegate

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    dataModel.indexOfSelectedChecklist = indexPath.row
    //NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: "ChecklistIndex")

    let checklist = self.dataModel.lists[indexPath.row]
    
    // Manually execuate prepareForSegue
    performSegueWithIdentifier("ShowChecklist", sender: checklist) // Putting checklist as sender

  }
  
  override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
    
    // Create the new controller (ListNavigationController)
    let navigationController = storyboard!.instantiateViewControllerWithIdentifier("ListNavigationController") as UINavigationController
    
    let controller = navigationController.topViewController as ListDetailViewController
    
    controller.delegate = self
    let checklist = self.dataModel.lists[indexPath.row]
    
    controller.checklistToEdit = checklist
    
    presentViewController(navigationController, animated: true, completion: nil)
    
  }
  
// MARK: - UINavigationControllerDelegate Delegate
  
  // This mehoid is called whenever the navigation controller will slide to a new screen.
  func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
    
    println("In UINavigationControllerDelegate willShowViewController")
    /// === means checking whether two variavles refer to the exact same object
    if viewController === self {
      dataModel.indexOfSelectedChecklist = -1
      //NSUserDefaults.standardUserDefaults().setInteger(-1, forKey: "ChecklistIndex")
    }
  
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
    
    let newRowIndex = self.dataModel.lists.count
    self.dataModel.lists.append(checklist)
    
    let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
    let indexPaths = [indexPath]
    self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func listDetailViewController(controller: ListDetailViewController, didFinishEditingChecklist checklist: Checklist) {
    
    if let index = find(self.dataModel.lists, checklist) {
      let indexPath = NSIndexPath(forRow: index, inSection: 0)
      if let cell = tableView.cellForRowAtIndexPath(indexPath) {
        cell.textLabel!.text = checklist.name
      }
    }
    
    dismissViewControllerAnimated(true, completion: nil)
  
  }
  



}