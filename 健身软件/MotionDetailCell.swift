//
//  MotionDetailCell.swift
//  健身软件
//
//  Created by CaptainSeanConner on 2017/3/1.
//  Copyright © 2017年 $CaptainConner$. All rights reserved.
//

import UIKit

class MotionDetailCell: UITableViewCell {

    
    
 
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var addButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        print("点击了按钮")
    }
    
    //设置控件的内容
    func setting(name:String,level:String) {
        
        print(name)
        self.imageview.frame = self.frame
        self.name.text = name
        self.level.text = level
        self.imageview.image = UIImage(named: name)
    }

}
