//
//  timerCell.swift
//  健身软件
//
//  Created by CaptainSeanConner on 2017/2/26.
//  Copyright © 2017年 $CaptainConner$. All rights reserved.
//

import UIKit

class timerCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timesLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    var cellTime:Int = 0
    var timer:Timer!
    var hour:Int = 0
    var min:Int = 0
    var sec:Int = 0
    var counter:Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.timesLabel.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

    @IBAction func burronPressed(_ sender: Any) {
        
        self.counter = self.cellTime
        if self.startButton.titleLabel?.text == "开始" {
            print("开始倒数")
            self.startButton.setTitle("取消", for: .normal)
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.anticlockwise), userInfo: nil, repeats: true)
            
        }else {
            print("取消倒数")
            self.startButton.setTitle("开始", for: .normal)
            self.timer.invalidate()
            resetTime()
        }
        
        
        
    }

    
    //倒数功能
   
    func anticlockwise() {
    
        if  self.counter > 0{
            self.counter -= 1
            self.hour = Int(counter/3600)
            self.min = Int((counter - hour*3600)/60)
            self.sec = Int((counter - hour*3600 - min*60))
            self.timesLabel.text = String.init(format:"%1$02d:%2$02d:%3$02d",self.hour,self.min,self.sec)
        }else {
            self.timer.invalidate()
            resetTime()
            self.startButton.setTitle("开始", for: .normal)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TimesUpNotification"), object: nil, userInfo: nil)
            
        }
        
    }
    
    //时间还原
    func resetTime() {
        self.hour = Int(cellTime/3600)
        self.min = Int((cellTime - hour*3600)/60)
        self.sec = Int((cellTime - hour*3600 - min*60))
        self.timesLabel.text = String.init(format:"%1$02d:%2$02d:%3$02d",self.hour,self.min,self.sec)
    }
    

        
        
        
    
    

    
}
