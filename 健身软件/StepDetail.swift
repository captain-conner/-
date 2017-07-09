//
//  StepDetail.swift
//  健身软件
//
//  Created by CaptainSeanConner on 2017/3/4.
//  Copyright © 2017年 $CaptainConner$. All rights reserved.
//

import UIKit

class StepDetail: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var theImageVIew: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    
   
    @IBOutlet weak var thePickerVIew: UIPickerView!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    //初始化这个页面有两种情况 1、在已添project下直接编辑(true) 2 、在新建的project下编辑。(false)
    var hasAdded:Bool = false
    
    var name:String!
    var detail:String!
    //属于哪个project 和rank ，在1情况调用
    var belong:String!
    var rank:Int!
    
    //picker修改之前的值
    var oldCounts:Int!
    var oldHour:Int!
    var oldMin:Int!
    var oldSec:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.thePickerVIew.delegate = self
        self.thePickerVIew.dataSource = self
        self.textView.text = self.detail
        self.theImageVIew.image = UIImage(named: self.name)
        
        //初始化picker view 让他选择没修改之前的值
        self.thePickerVIew.selectRow(self.oldCounts, inComponent: 0, animated: false)
        self.thePickerVIew.selectRow(self.oldHour, inComponent: 1, animated: false)
        self.thePickerVIew.selectRow(self.oldMin, inComponent: 2, animated: false)
        self.thePickerVIew.selectRow(self.oldSec, inComponent: 3, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //在 已添加project中编辑初始化专用
    func setForAddedStep(name:String,detail:String,belong:String,rank:Int,hasAdded:Bool,oldCounts:Int,oldTimes:Int) {
        self.name = name
        self.detail = detail
        self.belong = belong
        self.rank = rank
        self.hasAdded = hasAdded
        self.oldCounts = oldCounts
        self.oldHour = Int(oldTimes/3600)
        self.oldMin = Int((oldTimes - self.oldHour*3600)/60)
        self.oldSec = Int((oldTimes - self.oldHour*3600 - self.oldMin*60))
    }
    
    
    func setForNewProject(name:String,detail:String,oldCounts:Int,oldTimes:Int) {
        self.name = name
        self.detail = detail
        self.oldCounts = oldCounts
        self.oldHour = Int(oldTimes/3600)
        self.oldMin = Int((oldTimes - self.oldHour*3600)/60)
        self.oldSec = Int((oldTimes - self.oldHour*3600 - self.oldMin*60))
    }
    
    @IBAction func cancleButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        print("点击了确定按钮")
        let counts = self.thePickerVIew.selectedRow(inComponent: 0)
        let selectHour = self.thePickerVIew.selectedRow(inComponent: 1)
        let selectMin = self.thePickerVIew.selectedRow(inComponent: 2)
        let selectSec = self.thePickerVIew.selectedRow(inComponent: 3)
        
        //将添加动作的信息发送给上一个界面
        let times = selectHour*3600 + selectMin*60 + selectSec
        
        //判断是哪个页面跳转过来的
        if self.hasAdded == true {
            //情况1 直接更新 step表
            let step = STEP_LIST()
            step.update(name: self.name, belong: self.belong, times: times, counts: counts, rank: self.rank, newRank: self.rank)
            //发送修改信息，不用传递 数据，只要告诉信息 让superview 刷新
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AddedStepHaseEditNotification"), object: nil, userInfo: nil)
            
        }else if self.hasAdded == false {
            //情况2 直接发送修改的通知，给上层view
            print("发送了修改的消息")

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StepHaseEditNotification"), object: nil, userInfo: ["counts":counts,"times":times])
        }
        
        
        self.dismiss(animated: true, completion: nil)
    }

    
    //MARK -- pickerview delegete & datasource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            //动作次数 单个动作1000次，极限吧。
            return 1000
        }else {
            //时 、分 、 秒
            return 60
        }
    }
    

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let showLabel = UILabel()
        
        if component == 0 {
            showLabel.text = String.init(format: "%1$03d", row)
            
        }else {
            showLabel.text = String.init(format: "%1$02d", row)
            
        }
        return showLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let label = pickerView.view(forRow: row, forComponent: component) as! UILabel
        
        if component == 0 {
            label.text = "\(label.text!) 次数"
        }else if component == 1{
            label.text = "\(label.text!) 小时"
        }else if component == 2 {
            label.text = "\(label.text!) 分钟"
        }else if component == 3 {
            label.text = "\(label.text!) 秒"
        }
    }
    
}
