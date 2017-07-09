//
//  StepForProjece_cell.swift
//  健身软件
//
//  Created by CaptainSeanConner on 2017/3/3.
//  Copyright © 2017年 $CaptainConner$. All rights reserved.
//

import UIKit

class StepForProjece_cell: UITableViewCell {

    
    @IBOutlet weak var theImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var countsLabel: UILabel!
    
    @IBOutlet weak var timesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.theImage.frame = self.frame

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    
    func setting(name:String,counts:Int,times:Int) {
        self.theImage.image = UIImage(named: name)
        self.nameLabel.text = name
        self.countsLabel.text = "次数:X\(counts)"
        self.timesLabel.text = "时间:\(times) 秒"
    }
}
