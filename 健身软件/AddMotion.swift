//
//  AddMotion.swift
//  健身软件
//
//  Created by CaptainSeanConner on 2017/3/6.
//  Copyright © 2017年 $CaptainConner$. All rights reserved.
//

import UIKit

class AddMotion: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var textView: UITextView!
    var detail:String!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var theImageView: UIImageView!
    
    @IBOutlet weak var navigationbar: UINavigationBar!
    //navigation 按钮
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    //选择的次数 时间
    var name:String!
    var belong:String!
    var counts:Int!
    var hour:Int!
    @IBOutlet weak var textField: UITextField!
    var min:Int!
    var sec:Int!
    var  thePickerView:UIPickerView!
    var toolbar:UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        self.theImageView.image = UIImage(named: name)
        self.textView.text = self.detail
        //self.pickerView.delegate = self
        //self.pickerView.dataSource = self
        self.doneButton.isEnabled = false
        
        
        self.thePickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.thePickerView.delegate = self
        self.thePickerView.dataSource = self
        
        
        self.textField.isHidden = true
        
        /* toolbar 出现问题，pickerview没有响应按钮的点击，先用nvagigation代替
        //为pickerview 添加toolbar 确定和取消按钮
        self.toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 375, height: 44.0))
        //self.toolbar.barStyle = .blackOpaque
        let doneItemButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done_pickerButtonPressed))
        let cancelItemButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel_pickerButtonPressed))
        let flix = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([doneItemButton,flix,cancelItemButton], animated: true)
        //self.thePickerView.inputAccessoryView
        */
        self.textField.inputView = self.thePickerView
        
    }
    
    
    func setting(name:String,belong:String,detail:String) {
        print(name)
        self.name = name
        self.belong = belong
        self.theImageView.image = UIImage(named: name)
        self.textView.text = detail
        
    }
    

    //点击按钮的响应方法
    @IBAction func addButtonPressed(_ sender: Any) {
        
        self.doneButton.isEnabled = true
        
        self.textField.becomeFirstResponder()
        print("--------\(self.thePickerView.subviews)")
        
        
    }
    
    //点击确定按钮后 将step表的具体信息传给 上一个界面
    @IBAction func navdone_ButtonPressed(_ sender: Any) {
        
        print("点击了确定按钮")
        self.counts = self.thePickerView.selectedRow(inComponent: 0)
        let selectHour = self.thePickerView.selectedRow(inComponent: 1)
        let selectMin = self.thePickerView.selectedRow(inComponent: 2)
        let selectSec = self.thePickerView.selectedRow(inComponent: 3)
        
        //将添加动作的信息发送给上一个界面
        let times = selectHour*3600 + selectMin*60 + selectSec
        let rank = 9
        //let dic = NSDictionary(objects: [self.name,self.belong,self.counts,rank,times], forKeys: ["name" as NSCopying,"belong"as NSCopying,"counts"as NSCopying,"rank"as NSCopying,"times"as NSCopying])
        

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AddMotionToProject"), object: nil, userInfo: ["name":self.name,"belong":self.belong,"counts":self.counts,"rank":rank,"times":times])
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func navcancel_ButtonPressed(_ sender: Any) {
        print("点击了取消按钮")
        self.textField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
        
    }
    

    func done_pickerButtonPressed() {
        print("点击了 pickerview done按钮")
        
        self.textField.resignFirstResponder()
    }
    
    func cancel_pickerButtonPressed() {
        print("点击了 pickerview cancel按钮")
        self.textField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    
    
    
    //MARK -- PICKERVIEW delegate & datasource
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
  
    /*
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return String.init(format: "%1$03d", row)
        }else {
            return String.init(format: "%1$02d", row)
        }
    }
    */
    
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
        
        let showLabel = pickerView.view(forRow: row, forComponent: component) as! UILabel
        
        if component == 0 {
            showLabel.text = "\(showLabel.text!)  次数"
        }else if component == 1 {
            showLabel.text = "\(showLabel.text!)    小时"
        }else if component == 2 {
            showLabel.text = "\(showLabel.text!)    分钟"
        }else {
            showLabel.text = "\(showLabel.text!)    秒"
        }
    }
    /////end pickerview /////

}
