//
//  MotionDetail.swift
//  健身软件
//
//  Created by CaptainSeanConner on 2017/3/1.
//  Copyright © 2017年 $CaptainConner$. All rights reserved.
//

import UIKit

class MotionDetail: UIViewController {


    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var thenavigationbar: UINavigationBar!
    var detail:String!
    var imageName:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.label.text = self.detail
        self.imageView.image = UIImage(named: self.imageName)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
