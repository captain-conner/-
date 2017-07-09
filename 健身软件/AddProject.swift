//
//  AddProject.swift
//  健身软件
//
//  Created by CaptainSeanConner on 2017/3/2.
//  Copyright © 2017年 $CaptainConner$. All rights reserved.
//

import UIKit

class AddProject: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var projectName: UITextField!
    @IBOutlet weak var loop: UITextField!
    @IBOutlet weak var interval: UITextField!
    @IBOutlet weak var restTime: UITextField!
    
    @IBOutlet weak var addMotionButton: UIButton!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var theTableView: UITableView!
    @IBOutlet weak var cancleButton: UIBarButtonItem!
    
    
    var pcounts:Int!
    var ploop:Int!
    var pname:String!
    var pintarval:Int!
    var presttime:Int!
    
    //已添加的动作
    var motions_list:[NSDictionary] = [NSDictionary]()
    var selectedIndex:Int!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.theTableView.delegate = self
        self.theTableView.dataSource = self
        
        //添加动作后的消息处理
        NotificationCenter.default.addObserver(self, selector: #selector(self.acceptAddMotionMessage), name: NSNotification.Name(rawValue: "AddMotionToProject"), object: nil)
        //添加修改动作后的消息处理
        NotificationCenter.default.addObserver(self, selector: #selector(self.stepHasEditMessage(notification:)), name: NSNotification.Name(rawValue: "StepHaseEditNotification"), object: nil)
        
        
        //self.theTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        reflash()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func reflash() {
        if self.motions_list.count == 0 {
            self.theTableView.alpha = 0
            
        }else {
            self.theTableView.alpha = 0.8
        }
        self.theTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.theTableView.reloadData()
    }
    
    //接收到添加动作的消息
    func acceptAddMotionMessage(notification:Notification) {
        print("接收到添加动作消息")
        let dic = NSDictionary(dictionary: notification.userInfo!)
        self.motions_list.append(dic)
        
        
        reflash()
    }
    
    func stepHasEditMessage(notification:Notification) {
        print("接受到修改动作细节消息")
        print("刚才选中的cell index 为： \(self.selectedIndex)")
        let dic = NSDictionary(dictionary: notification.userInfo!)
        let counts_of_cell = dic.value(forKey: "counts") as! Int
        let times_of_cell = dic.value(forKey: "times") as! Int
        //因为nsdictionary 不能修改内容，所以要先转化
        let temp = NSMutableDictionary(dictionary: self.motions_list[self.selectedIndex])
        temp.setValue(counts_of_cell, forKey: "counts")
        temp.setValue(times_of_cell, forKey: "times")
        //删除应该改变的位置nsdictionary
        self.motions_list.remove(at: self.selectedIndex)
        self.motions_list.insert(temp as NSDictionary, at: self.selectedIndex)
        
        reflash()
        
    }
    
    //MARK -- tableview delegate & datasource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.motions_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.theTableView.dequeueReusableCell(withIdentifier: "added_in_project", for: indexPath) as! Added_InProject_cell
        
        let dic = self.motions_list[indexPath.row]
        let name = dic.value(forKey: "name") as! String
        let counts = dic.value(forKey: "counts") as! Int
        let times = dic.value(forKey: "times") as! Int
        cell.setting(name: name, counts: counts, times: times)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.motions_list.remove(at: indexPath.row)
            reflash()
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.selectedIndex = indexPath.row
        return indexPath
    }
    
    
    
    ///////////tableview end ////////////////
    
    //MARK-- textfield delegate
    //隐隐藏键盘
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.projectName.resignFirstResponder()
        self.loop.resignFirstResponder()
        self.interval.resignFirstResponder()
        self.restTime.resignFirstResponder()
        
        return true
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit_step" {
            let vc = segue.destination as! StepDetail
            vc.modalTransitionStyle = .flipHorizontal
            
            let dic = self.motions_list[self.selectedIndex]
            let name = dic.value(forKey: "name") as! String
            
            let motion = MOTION_LIST().searchProperty(propertyName: "name", propertyValue: name)
            let motion_dic = motion[0]
            //vc.name = name
            let detail = motion_dic.value(forKey: "detail") as! String
            //vc.detail = detail
            let oldCounts = dic.value(forKey: "counts")as! Int
            let oldTimes = dic.value(forKey: "times") as! Int
            
            vc.setForNewProject(name: name, detail: detail, oldCounts: oldCounts, oldTimes: oldTimes)
            print("\(name) \(detail)")
            
        }
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        
        if self.projectName.text == "" {
            showAlert(message: "名字不能为空")
        }else if self.loop.text == "" {
            showAlert(message: "循环次数不能为空")
        }else if self.interval.text == "" {
            showAlert(message: "间隔不能为空")
        }else if self.restTime.text == "" {
            showAlert(message: "循环休息时间不能为空")
        
        }else if self.motions_list.count == 0 {
            showAlert(message: "还没添加动作")
        }else {
            self.pname = self.projectName.text
            self.ploop = Int(self.loop.text!)
            self.pintarval = Int(self.interval.text!)
            self.presttime = Int(self.restTime.text!)
            
            //将全部动作写入到数据库step表和project表
            let project = PROJECT_LIST()
            let step = STEP_LIST()
            
            
            //写入project表
            print("写入 project 表 \(self.pname) \(self.pintarval) \(self.ploop) \(self.presttime)")
            project.insert(name: self.pname, interval: self.pintarval, loop: self.ploop, resttime: self.presttime)
            
            //写入step表
            
            var rank_count = 0
            for eachStep in self.motions_list {
                let name = eachStep.value(forKey: "name") as! String
                
                let times = eachStep.value(forKey: "times") as! Int
                let counts = eachStep.value(forKey: "counts") as! Int
                
                print("写入 step表 \(name) \(self.pname) \(times) \(counts) \(rank_count)")
                step.insert(name:name, belong: self.pname, times: times, counts: counts, rank: rank_count)
                
                rank_count += 1
            }
        }
        
        self.dismiss(animated: true, completion: nil)
        //添加完数据库之后返回主页，发送成功的消息让主页重新刷新
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AddProjectSuccessNotification"), object: nil, userInfo: nil)
    }
    
    
    //提醒功能
    func showAlert(message:String) {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default, handler: nil)
        alertController.addAction(action)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //点击空白隐藏键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.projectName.resignFirstResponder()
        self.loop.resignFirstResponder()
        self.interval.resignFirstResponder()
        self.restTime.resignFirstResponder()
    }
}
