//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Ryan on 2015/2/7.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
  func itemDetailViewControllerDidCancel(controller: ItemDetailViewController)
  
  // Add New Item
  func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem)
  
  // Eiit Item
  func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem)
}


class ItemDetailViewController: UITableViewController, UITextFieldDelegate {

  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  @IBOutlet weak var shouldRemindSwitch: UISwitch!
  @IBOutlet weak var dueDateLabel: UILabel!
  
  var dueDate = NSDate()
  var datePickerVisible = false
  
  
  // ? means it's optional
  weak var delegate: ItemDetailViewControllerDelegate?
  var itemToEdit: ChecklistItem?
  
// MARK - Controller Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    // Add this line for bug in ios8
    self.tableView.rowHeight = 44;
    
    // Unwrap the optional
    if let item = itemToEdit {
      title = "Edit Item"
      self.textField.text = item.text
      self.doneBarButton.enabled = true
      self.shouldRemindSwitch.on = item.shouldRemind
      self.dueDate = item.dueDate
    }
    
    updateDueDateLabel()
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    // Make the textField be auto focus (keyboard will appear automatically)
    self.textField.becomeFirstResponder()
  }
  
  /* Test 
  override func viewDidAppear(animated: Bool) {
    println("In ViewDidAppear")
    let indexPathDateRow = NSIndexPath(forRow: 1, inSection: 1)
    
    if let dateCell = tableView.cellForRowAtIndexPath(indexPathDateRow) {
      dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
    }
    super.viewDidAppear(animated)
  }
  */

// MARK: - Action
  
  @IBAction func cancel() {
    
    delegate?.itemDetailViewControllerDidCancel(self)
    // Telling to the "presinting view controller" to close the screen with an animation
    //dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func done() {
    
    if let item = itemToEdit {
      item.text = textField.text
      item.shouldRemind = shouldRemindSwitch.on
      item.dueDate = self.dueDate
      item.scheduleNotification()
      delegate?.itemDetailViewController(self, didFinishEditingItem: item)
    } else {
      let item = ChecklistItem()
      item.text = textField.text
      item.checked = false
      item.shouldRemind = shouldRemindSwitch.on
      item.dueDate = self.dueDate
      item.scheduleNotification()
      delegate?.itemDetailViewController(self, didFinishAddingItem: item)
    }
  
    //dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func shouldRemindToggled(switchControl: UISwitch) {
    self.textField.resignFirstResponder()
    if switchControl.on {
      let notificationSettings = UIUserNotificationSettings(forTypes: .Alert | .Sound, categories: nil)
      
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    }
  }
  
  
  
  // MARK: - updateUI
  func updateDueDateLabel() {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .MediumStyle
    formatter.timeStyle = .ShortStyle
    self.dueDateLabel.text = formatter.stringFromDate(self.dueDate)
    
  }
  
  func showDatePicker() {
    
    self.datePickerVisible = true
    
    let indexPathDateRow = NSIndexPath(forRow: 1, inSection: 1)
    let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 1)
    
    if let dateCell = tableView.cellForRowAtIndexPath(indexPathDateRow) {
      dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
    }
    
    tableView.beginUpdates()
    tableView.insertRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
    
    // ???
    tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
    
    tableView.endUpdates()


    if let pickerCell = tableView.cellForRowAtIndexPath(indexPathDatePicker) {
      let datePicker = pickerCell.viewWithTag(100) as UIDatePicker
      datePicker.setDate(self.dueDate, animated: false)
    }
  }
  
  func hideDatePicker() {
    if datePickerVisible {
      datePickerVisible = false
      
      let indexPathDateRow = NSIndexPath(forRow: 1, inSection: 1)
      let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 1)
      
      if let cell = tableView.cellForRowAtIndexPath(indexPathDateRow) {
        cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
      }
      
      tableView.beginUpdates()
      tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
      tableView.deleteRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
      tableView.endUpdates()
    
    }
  }
  
  func dateChanged(datePicker: UIDatePicker) {
    self.dueDate = datePicker.date
    updateDueDateLabel()
  }
  
  
// MARK: - Data Source
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    //println("In numberOfRowsInSection")
    
    if section == 1 && datePickerVisible {
      return 3
    } else {
      return super.tableView(tableView, numberOfRowsInSection: section)
    }
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //println("In cellForRowAtIndexPath")
    //println("indexPath.section: \(indexPath.section)   indexPath.row: \(indexPath.row)")
    // 1
    if indexPath.section == 1 && indexPath.row == 2 {
      // 2
      var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("DatePickerCell") as? UITableViewCell
      
      if cell == nil {
        cell = UITableViewCell(style: .Default, reuseIdentifier: "DatePickerCell")
        cell.selectionStyle = .None
        
        // 3
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width:320, height: 216))
        datePicker.tag = 100
        cell.contentView.addSubview(datePicker)
        
        // 4
        datePicker.addTarget(self, action: Selector("dateChanged:"), forControlEvents: .ValueChanged)
      }
      return cell
      
      // 5
    } else {
      return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }
  }
  
  
  
  

// MARK: - Delegate
  override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    
    if indexPath.section == 1 && indexPath.row == 1 {
      return indexPath
    } else {
      return nil
    }
  }
  
  // It's invoked every time the user changes the text, whether by tapping on the keyboard or cut/paste
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    
    // We want to use stringByReplacingCharactersInRange method, so we declare they are NSString
    let oldText: NSString = textField.text
    let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
    
    //println("replacementString: \(string)")
    //println("range location: \(range.location)")
    //println("range length: \(range.length)")
    
    doneBarButton.enabled = (newText.length > 0)
    return true
  }
  
  
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    // Hide the on-sereen keyboard
    textField.resignFirstResponder()
    
    if indexPath.section == 1 && indexPath.row == 1 {
      if !datePickerVisible{
        showDatePicker()
      } else {
        hideDatePicker()
      }
    }
    
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
    if indexPath.section == 1 && indexPath.row == 2 {
      
      return 217
    } else {
      return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
  }
  
  //設置縮排
  override func tableView(tableView: UITableView, var indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
    
    //println("In indentationLevelForRowAtIndexPath")
    if indexPath.section == 1 && indexPath.row == 2 {
      indexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
    }
    
    return super.tableView(tableView, indentationLevelForRowAtIndexPath: indexPath)
    
  }
  
  func textFieldDidBeginEditing(textField: UITextField) {
    hideDatePicker()
  }


}


