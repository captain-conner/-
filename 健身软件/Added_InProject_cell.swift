//
//  Added_InProject_cell.swift
//  健身软件
//
//  Created by CaptainSeanConner on 2017/3/6.
//  Copyright © 2017年 $CaptainConner$. All rights reserved.
//

import UIKit

class Added_InProject_cell: UITableViewCell {

    //added_in_project
    @IBOutlet weak var theImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
  
    @IBOutlet weak var timeLabel: UILabel!
    
    //var name:String!
    //var times:Int!
    //var counts:Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.theImageView.frame = self.frame
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    
    func setting(name:String,counts:Int,times:Int) {
        self.theImageView.image = UIImage(named: name)
        self.nameLabel.text = name
        print("setting 中赋值 \(name)")
        self.countLabel.text = "\(counts)"
        self.timeLabel.text = "\(times)"
    }
}
