//
//  timeDetail.swift
//  健身软件
//
//  Created by CaptainSeanConner on 2017/3/11.
//  Copyright © 2017年 $CaptainConner$. All rights reserved.
//

import UIKit

class timeDetail: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var thePickerView: UIPickerView!
    @IBOutlet weak var clockImage: UIImageView!
    
    @IBOutlet weak var clockName: UILabel!
    
    @IBOutlet weak var clockLabel: UILabel!
    var countDownTime:Int!
    
    @IBOutlet weak var start_and_pause_Button: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    var timer:Timer!
    var timeName:String!
    var times:Int!
    var counter:Int = 0
    var hour:Int!
    var min:Int!
    var sec:Int!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.thePickerView.delegate = self
        self.thePickerView.dataSource = self
        //一开始时钟显示和取消按钮都是隐藏的，点击开始的时候才显示
        self.clockLabel.isHidden = true
        self.cancelButton.isHidden = true
        self.clockImage.isHidden = true
        
        self.clockName.text = self.timeName
        resetTime()
        self.thePickerView.selectRow(self.hour, inComponent: 0, animated: true)
        self.thePickerView.selectRow(self.min, inComponent: 1, animated: true)
        self.thePickerView.selectRow(self.sec, inComponent: 2, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func initView(timeName:String,times:Int) {
        
        self.timeName = timeName
        self.times = times
        self.counter = times
        
        
    }
    
    
    //MARK PICKERVIEW delegate & datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel()
        label.text = " \(row)"
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let label = self.thePickerView.view(forRow: row, forComponent: component) as! UILabel
        
        if component == 0 {
            if label.text?.contains("小时") == false {
                label.text = "\(label.text!) 小时"
            }
            self.hour = row
            changeTime(chour: row, cmin: nil, csec: nil)
            
        }else if component == 1 {
            if label.text?.contains("分钟") == false {
                label.text = "\(label.text!) 分钟"
                
            }
            self.min = row
            changeTime(chour: nil, cmin: row, csec: nil)
            
        }else {
            if label.text?.contains("秒") == false {
                label.text = "\(label.text!) 秒"
            }
            self.sec = row
            changeTime(chour: nil, cmin: nil, csec: row)
        }
        
    }
    /////end pickerview
    
    
    
    @IBAction func start_and_pauseButtonPressed(_ sender: Any) {
        self.clockImage.isHidden = false
        self.cancelButton.isHidden = false
        self.clockLabel.isHidden = false
        self.thePickerView.isHidden = true
        
        if self.start_and_pause_Button.tag == 0 {
            print("开始计时")
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.anticlockwise), userInfo: nil, repeats: true)
            self.start_and_pause_Button.setTitle("暂停", for: .normal)
            self.start_and_pause_Button.tag = 1
            self.start_and_pause_Button.setImage(UIImage(named: "pause"), for: .normal)
            
        }else {
            print("暂停计时")
            self.timer.invalidate()
            self.start_and_pause_Button.setTitle("开始", for: .normal)
            self.start_and_pause_Button.tag = 0
            self.start_and_pause_Button.setImage(UIImage(named: "start"), for: .normal)
        }
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        if self.timer != nil {
            self.timer.invalidate()
        }
        
        self.start_and_pause_Button.tag = 0
        self.start_and_pause_Button.setTitle("开始", for: .normal)
        self.start_and_pause_Button.setImage(UIImage(named: "start"), for: .normal)
        resetTime()

    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        if self.timer != nil {
            self.timer.invalidate()
        }
        self.clockImage.isHidden = true
        self.thePickerView.isHidden = false
        self.cancelButton.isHidden = true
        self.clockLabel.isHidden = true
        self.start_and_pause_Button.tag = 0
        self.start_and_pause_Button.setTitle("开始", for: .normal)
        self.start_and_pause_Button.setImage(UIImage(named: "start"), for: .normal)
        resetTime()
    }
    
    //倒数功能
    
    func anticlockwise() {
        
        if  self.counter > 0{
            self.counter -= 1
            self.hour = Int(counter/3600)
            self.min = Int((counter - hour*3600)/60)
            self.sec = Int((counter - hour*3600 - min*60))
            self.clockLabel.text = String.init(format:"%1$02d:%2$02d:%3$02d",self.hour,self.min,self.sec)
        }else {
            self.timer.invalidate()
            resetTime()
            self.counter = self.times
            self.start_and_pause_Button.setTitle("开始", for: .normal)
            self.start_and_pause_Button.tag = 0
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TimesUpNotification"), object: nil, userInfo: nil)
            //重置
            self.start_and_pause_Button.setImage(UIImage(named: "start"), for: .normal)
            
        }
        
    }
    
    //时间还原
    func resetTime() {
        self.start_and_pause_Button.tag = 0
        self.start_and_pause_Button.setTitle("开始", for: .normal)
        self.counter = self.times
        self.hour = Int(self.times/3600)
        self.min = Int((self.times - hour*3600)/60)
        self.sec = Int((self.times - hour*3600 - min*60))
        self.clockLabel.text = String.init(format:"%1$02d:%2$02d:%3$02d",self.hour,self.min,self.sec)
        
    }

    //重新选择了时间，调用该函数，写入数据库，重新装载新的时间
    func changeTime(chour:Int?,cmin:Int?,csec:Int?) {
        
        if chour != nil {
            self.hour = chour
        }else if cmin != nil {
            self.min = cmin
        }else if csec != nil {
            self.sec = csec
        }
        
        
        self.times = self.hour*3600 + self.min*60 + self.sec
        self.counter = self.times
        
        print("时间更新 \(self.hour) :\(self.min) :\(self.sec)")
        //发送时间更新的信息给上一级
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TimesChangeNotification"), object: nil, userInfo: ["name":self.timeName,"times":self.times])
        
        
    }

    
}
