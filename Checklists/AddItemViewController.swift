//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Ryan on 2015/2/7.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import UIKit

protocol AddItemViewControllerDelegate: class {
  func addItemViewControllerDidCancel(controller: AddItemViewController)
  
  // Add New Item
  func addItemViewController(controller: AddItemViewController, didFinishAddingItem item: ChecklistItem)
  
  // Eiit Item
  func addItemViewController(controller: AddItemViewController, didFinishEditingItem item: ChecklistItem)
}


class AddItemViewController: UITableViewController, UITextFieldDelegate {

  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  // ? means it's optional
  weak var delegate: AddItemViewControllerDelegate?
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
    }
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    // Make the textField be auto focus (keyboard will appear automatically)
    self.textField.becomeFirstResponder()
  }
  

// MARK - Action
  
  @IBAction func cancel() {
    
    delegate?.addItemViewControllerDidCancel(self)
    // Telling to the "presinting view controller" to close the screen with an animation
    //dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func done() {
    
    if let item = itemToEdit {
      item.text = textField.text
      delegate?.addItemViewController(self, didFinishEditingItem: item)
    } else {
      let item = ChecklistItem()
      item.text = textField.text
      item.checked = false
      
      delegate?.addItemViewController(self, didFinishAddingItem: item)
    }
  
    //dismissViewControllerAnimated(true, completion: nil)
  }
  

// MARK - Delegate
  override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    
    return nil
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

}


