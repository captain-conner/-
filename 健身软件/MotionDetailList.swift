//
//  MotionDetailList.swift
//  健身软件
//
//  Created by CaptainSeanConner on 2017/3/1.
//  Copyright © 2017年 $CaptainConner$. All rights reserved.
//

import UIKit

class MotionDetailList: UITableViewController {

    var cell_list:[NSDictionary]!
    var selectedRow = 0
    //和view will disappear 配合判断是否回到motionscontroller
    var isBackToMotions = true
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("二级cell \(self.cell_list.count)")
        return self.cell_list.count
        
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.frame.height / 6)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "motion_detail", for: indexPath) as! MotionDetailCell

        let name = self.cell_list[indexPath.row].value(forKey: "name") as! String
        
        cell.setting(name: name, level: "123")
        return cell
    }
 
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.selectedRow = indexPath.row
        
        return indexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detail" {
            
            self.isBackToMotions = false
            
            print(self.selectedRow)
            let vc = segue.destination as! MotionDetail
            let label =  self.cell_list[self.selectedRow].value(forKey: "detail") as! String
            let imageName = self.cell_list[self.selectedRow].value(forKey: "name") as! String
            print(label)
            print(imageName)
            vc.detail = label
            vc.imageName = imageName
            
        }
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        print("will disapear =========================")
        if self.isBackToMotions == true {
            //重新开始上一个页面的滑动
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StartRollingMotionsControllerNotification"), object: nil, userInfo: nil)
        }else {
             self.isBackToMotions = true
        }
      
       
    }
    
    

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
