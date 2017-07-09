//
//  AddTimer.swift
//  健身软件
//
//  Created by CaptainSeanConner on 2017/2/26.
//  Copyright © 2017年 $CaptainConner$. All rights reserved.
//

import UIKit

class AddTimer: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {

    
    @IBOutlet weak var timePicker: UIPickerView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    
    @IBOutlet weak var label: UILabel!
    //设置时间
    var hour:Int32 = 0
    var min:Int32 = 0
    var sec:Int32 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timePicker.delegate = self
        self.timePicker.dataSource = self
        //self.timePicker.showsSelectionIndicator = true
        
        self.nameTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //点击添按钮
    @IBAction func doneButtonPress(_ sender: Any) {
        self.hour = Int32(self.timePicker.selectedRow(inComponent: 0))
        self.min = Int32(self.timePicker.selectedRow(inComponent: 1))
        self.sec = Int32(self.timePicker.selectedRow(inComponent: 2))
        
        
        if self.nameTextField.text != "" {
            print("发送返回消息")
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TimeHasAddNotification"), object: self, userInfo: nil)
            self.dismiss(animated: true, completion: nil)
            //self.performSegue(withIdentifier: "back_to_colck", sender: self)
            
        }
    }
    

   
    @IBAction func cancleButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK -- pickerview delegate & datesource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 24
        } else {
            return 60
        }
    }
    
    //设置标题
    /*
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    
  
        return String.init(format: "%1$02d", row)
    
    }
    
    */
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        
        let showText = UILabel()
        showText.text = String.init(format: "%1$02d", row)
        
        return showText
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let  text = self.timePicker.view(forRow: row, forComponent: component) as! UILabel
        if component == 0 {
            text.text = "\(text.text!)    小时"
        }else if component == 1 {
            text.text = "\(text.text!)    分钟"
        }else if component == 2 {
            text.text = "\(text.text!)    秒"
        }else {
            text.text = "\(text.text!)秒"
        }
        
    }
    
    //MARK -- textfield delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("点击了return 按键")
        self.nameTextField.resignFirstResponder()
        return true
    }
    
    
    
    
}
