//
//  SettingViewController.swift
//  Audience
//
//  Created by 이요한 on 2020/02/13.
//  Copyright © 2020 yo. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {
  
  
  // MARK: - Variable
  
  var playVC: PlayViewController?
  
  
  // MARK: - Oulet
  @IBOutlet var progressBarStyleButton: UISegmentedControl!
  
  // MARK: - Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
      playVC = self.tabBarController?.viewControllers![0] as? PlayViewController
      
    }

  
  // MARK: - Action
  
  @IBAction func tapProgressBarStyleButton(_ sender: Any) {
    
    if progressBarStyleButton.selectedSegmentIndex == 0 {
    //UserDefaultManager.saveProgressBarStyle("fluid")
      playVC?.setFluidSlider()
      
    
    } else if progressBarStyleButton.selectedSegmentIndex == 1{
    //UserDefaultManager.saveProgressBarStyle("jelly")
      playVC?.setJellySlider()
      playVC?.slider.removeFromSuperview()
    }
    
  }
  
  
  
    // MARK: - Table view

  
  
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
