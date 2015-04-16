//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by Ryan on 2015/2/11.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import UIKit

protocol IconPickerViewControllerDelegate: class {

  func iconPicker(picker: IconPickerViewController, didPickIcon iconName: String)
}


class IconPickerViewController: UITableViewController {
  
  weak var delegate: IconPickerViewControllerDelegate?
  let icons = [
      "No Icon",
      "Appointments",
      "Birthdays",
      "Chores",
      "Drinks",
      "Folder",
      "Groceries",
      "Inbox",
      "Photos",
      "Trips"]

  override func viewDidLoad() {
      super.viewDidLoad()

  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }


  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    return icons.count
  }

 
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("IconCell", forIndexPath: indexPath) as! UITableViewCell

      let iconName = icons[indexPath.row]
      cell.textLabel!.text = iconName
      cell.imageView!.image = UIImage(named: iconName)

      return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
  
    if let delegate = self.delegate {
      let iconName = self.icons[indexPath.row]
      delegate.iconPicker(self, didPickIcon: iconName)
    }
  
  }


  /*
  // Override to support conditional editing of the table view.
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
      // Return NO if you do not want the specified item to be editable.
      return true
  }
  */

  /*
  // Override to support editing the table view.
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
      if editingStyle == .Delete {
          // Delete the row from the data source
          tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
      } else if editingStyle == .Insert {
          // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
      }    
  }
  */

  /*
  // Override to support rearranging the table view.
  override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

  }
  */

  /*
  // Override to support conditional rearranging of the table view.
  override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
      // Return NO if you do not want the item to be re-orderable.
      return true
  }
  */

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      // Get the new view controller using [segue destinationViewController].
      // Pass the selected object to the new view controller.
  }
  */

}
