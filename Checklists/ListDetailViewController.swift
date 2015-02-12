//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Ryan on 2015/2/9.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {
  func listDetailViewControllerDidCancel(controller: ListDetailViewController)
  
  func listDetailViewController(controller: ListDetailViewController, didFinishAddingChecklist checklist: Checklist)
  
  func listDetailViewController(controller: ListDetailViewController, didFinishEditingChecklist checklist: Checklist)
}


class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {

  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  
  @IBOutlet weak var iconImageView: UIImageView!
  
  weak var delegate: ListDetailViewControllerDelegate?
  
  var checklistToEdit: Checklist?
  var iconName = "Folder"

// MARK - Controller Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.rowHeight = 44
    
    if let checklist = checklistToEdit {
      self.title = "Edit Checklist"
      self.textField.text = checklist.name
      self.doneBarButton.enabled = true
      self.iconName = checklist.iconName
    }
    
    self.iconImageView.image = UIImage(named: self.iconName)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }

// MARK: - Table View Delegate
  
  override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    
    if indexPath.section == 1 {
      return indexPath
    } else {
      return nil
    }
    
  }
  
// MARK: - TextField Delegate
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
  
    let oldText: NSString = textField.text
    let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
    
    self.doneBarButton.enabled = (newText.length > 0)
    
    return true
  }
  
// MARK: - IconPickerViewControllerDelegate Delegate
  
  func iconPicker(picker: IconPickerViewController, didPickIcon iconName: String) {
  
    self.iconName = iconName
    self.iconImageView.image = UIImage(named: iconName)
    // Because the Icon Picker is on the navigation stack
    navigationController?.popViewControllerAnimated(true)
  }
  
  
  
// MARK: - Action
  

  @IBAction func cancel() {
    delegate?.listDetailViewControllerDidCancel(self)
  }
  
  @IBAction func done() {
    if let checklist = checklistToEdit {
      // Edit checlist
      let checklist = Checklist(name: self.textField.text, iconName: self.iconName)
      
      delegate?.listDetailViewController(self, didFinishEditingChecklist: checklist)
    } else {
      // Add new checklist
      let checklist = Checklist(name: self.textField.text)
      checklist.iconName = self.iconName
      delegate?.listDetailViewController(self, didFinishAddingChecklist: checklist)
    }
  }
  
  
// MARK: - Navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "PickIcon" {
      let controller = segue.destinationViewController as IconPickerViewController
      controller.delegate = self
    }
  }

}
