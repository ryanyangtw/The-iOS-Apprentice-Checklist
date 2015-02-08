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
    }
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    // Make the textField be auto focus (keyboard will appear automatically)
    self.textField.becomeFirstResponder()
  }
  

// MARK - Action
  
  @IBAction func cancel() {
    
    delegate?.itemDetailViewControllerDidCancel(self)
    // Telling to the "presinting view controller" to close the screen with an animation
    //dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func done() {
    
    if let item = itemToEdit {
      item.text = textField.text
      delegate?.itemDetailViewController(self, didFinishEditingItem: item)
    } else {
      let item = ChecklistItem()
      item.text = textField.text
      item.checked = false
      
      delegate?.itemDetailViewController(self, didFinishAddingItem: item)
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


