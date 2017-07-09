//
//  UserProject.swift
//  健身软件
//
//  Created by CaptainSeanConner on 2017/3/3.
//  Copyright © 2017年 $CaptainConner$. All rights reserved.
//

import UIKit

class UserProject: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var timesLabel: UILabel!
    @IBOutlet weak var loopLabel: UILabel!
    @IBOutlet weak var theTableView: UITableView!
    @IBOutlet weak var cancleButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    //弹出pickerview用到的中间件
    @IBOutlet weak var textField: UITextField!
    var thePickerView:UIPickerView!
    
    //休息间隔，循环次数，休息时间
    var ProjectInterval:Int!
    var ProjectLoop:Int!
    var ProjectResttime:Int!
    
    
    
    @IBOutlet weak var autoModeButton: UIButton!
    @IBOutlet weak var manualModeButton: UIButton!
    //step_cell
    
    var projectName:String!
    var step_list:[NSDictionary]!
    var step:STEP_LIST!
    
    
    var selectedIndex:Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.theTableView.delegate = self
        self.theTableView.dataSource = self
        
        //数据树初始化
        self.step = STEP_LIST()
        print(self.projectName)
        self.step_list = self.step.searchBelong(name: self.projectName)
        
        let project = PROJECT_LIST()
        let project_dic = (project.search(name: self.projectName))[0]
        self.ProjectLoop = project_dic.value(forKey: "loop") as! Int
        self.ProjectInterval = project_dic.value(forKey: "interval") as! Int
        self.ProjectResttime = project_dic.value(forKey: "resttime") as! Int
        self.loopLabel.text = "循环 \(self.ProjectLoop!) 次"
        self.intervalLabel.text = "组间休息 \(self.ProjectInterval!) 秒"
        self.timesLabel.text = "轮间休息 \(self.ProjectResttime!) 秒"
        
        self.theTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.theTableView.tableFooterView?.alpha = 0
        
        
        //设置弹出的pickerview
        self.textField.isHidden = true
        self.thePickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.thePickerView.delegate = self
        self.thePickerView.dataSource = self
        self.textField.inputView = self.thePickerView
        self.thePickerView.selectRow(self.ProjectLoop, inComponent: 0, animated: false)
        self.thePickerView.selectRow(self.ProjectInterval, inComponent: 1, animated: false)
        self.thePickerView.selectRow(self.ProjectResttime, inComponent: 2, animated: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reflash), name: NSNotification.Name(rawValue: "AddedStepHaseEditNotification"), object: nil)
        
        reflash()
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func reflash() {
        print("刷新 \(self.projectName)")
        self.step = STEP_LIST()
        self.step_list = self.step.searchBelong(name: self.projectName)
        self.theTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.theTableView.tableFooterView?.alpha = 0
        self.theTableView.reloadData()
        
    }
    
    
    func setProjectName(name:String) {
        self.projectName = name
    }
    
    
    func showAlert(message:String) {
        if message == "delete_project" {
            
        }
    }
    
    //MARK -- tableview delegate & datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.step_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.theTableView.dequeueReusableCell(withIdentifier: "step_cell", for: indexPath) as! StepForProjece_cell
        
        let dic = self.step_list[indexPath.row]
        let name = dic.value(forKey: "name") as! String
        let counts = dic.value(forKey: "counts") as! Int
        let times = dic.value(forKey: "times") as! Int
        cell.setting(name: name, counts: counts, times: times)
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare for")
        if segue.identifier == "detail_for_step" {
            let vc = segue.destination as! StepDetail
            vc.modalTransitionStyle = .flipHorizontal
            
            let dic = self.step_list[self.selectedIndex]
            let name = dic.value(forKey: "name") as! String
            let oldCounts = dic.value(forKey: "counts")as! Int
            let oldTimes = dic.value(forKey: "times")as! Int
            
            
            let motion = MOTION_LIST().searchProperty(propertyName: "name", propertyValue: name)
            let motion_dic = motion[0]
            
            
            let detail = motion_dic.value(forKey: "detail") as! String
            //设置属性
            //vc.setForAddedStep(name: name, detail: detail, belong: self.projectName, rank: self.selectedIndex, hasAdded: true)
            vc.setForAddedStep(name: name, detail: detail, belong: self.projectName, rank: self.selectedIndex, hasAdded: true, oldCounts: oldCounts, oldTimes: oldTimes)
            print("\(name) \(detail)")
            
        }
        
        let project = PROJECT_LIST().search(name: self.projectName)
        let project_dic = project[0]
        self.ProjectLoop = project_dic.value(forKey: "loop") as! Int
        self.ProjectInterval = project_dic.value(forKey: "interval") as! Int
        
        self.ProjectResttime = project_dic.value(forKey: "resttime") as! Int
        
        
        if segue.identifier == "auto_mode" {
            print("进入自动模式")
            let vc = segue.destination as! AutoOrManual_StartProject
            vc.mode = "auto"
            vc.step_list = self.step_list
            vc.loop = self.ProjectLoop
            vc.interval = self.ProjectInterval
            vc.resttime = self.ProjectResttime
            
        }
        
        if segue.identifier == "manual_mode" {
            print("进入手动模式")
            let vc = segue.destination as! AutoOrManual_StartProject
            vc.mode = "manual"
            vc.step_list = self.step_list
            vc.loop = self.ProjectLoop
            vc.interval = self.ProjectInterval
            vc.resttime = self.ProjectResttime

        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print("will selected")
        self.selectedIndex = indexPath.row
        
        return indexPath
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.theTableView.frame.height / 5
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //删除操作时
        
        if editingStyle == .delete {
            
            
            var dic = self.step_list[indexPath.row]
            let name = dic.value(forKey: "name") as! String
            let belong = dic.value(forKey: "belong") as! String
            let rank = dic.value(forKey: "rank") as! Int
            print("开始删除 \(rank)")
            self.step.delete(name: name, belong: belong, rank: rank)
            
            let r = rank + 1
            for x in r..<self.step_list.count {
                dic = self.step_list[x]
                let name = dic.value(forKey: "name") as! String
                let belong = dic.value(forKey: "belong") as! String
                let oldRank = dic.value(forKey: "rank") as! Int
                let times = dic.value(forKey: "times") as! Int
                let counts = dic.value(forKey: "counts") as! Int
                let newRank = oldRank-1
                print("\(name) \(belong) \(oldRank)")
                self.step.update(name: name, belong: belong, times: times, counts: counts, rank: oldRank, newRank: newRank)
            }
            
        }
        self.step_list = self.step.searchBelong(name: self.projectName)
        //如果全部动作都删除完了，弹出警告是否删除项目
        if self.step_list.count == 0 {
            showAlert(message: "delete_project")
        }
        self.theTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let temp = self.step_list[sourceIndexPath.row]
        self.step_list.remove(at: sourceIndexPath.row)
        self.step_list.insert(temp, at: destinationIndexPath.row)
        
        let sourceRank:Int = sourceIndexPath.row
        let destRank:Int = destinationIndexPath.row
        
        let step = STEP_LIST()
        var dic:NSDictionary!
        //往上移动
        if sourceRank > destRank {
            for x in destinationIndexPath.row ... (sourceIndexPath.row-1) {
                print("-------------------往上移动")
                print(x)
                
                dic = self.step_list[x]
                let name = dic.value(forKey: "name") as! String
                let belong = dic.value(forKey: "belong") as! String
                let times = dic.value(forKey: "times") as! Int
                let oldRank = dic.value(forKey: "rank") as! Int
                let counts = dic.value(forKey: "counts") as! Int
                let newRank = oldRank+1
                step.update(name: name, belong: belong, times: times, counts: counts, rank: oldRank, newRank: newRank)
 
            }
            
        }else if destRank > sourceRank {
        //往下移动
            for x in (sourceIndexPath.row+1) ... destinationIndexPath.row {
                print("-------------------往下移动")
                print(x)
                /*
                let dic = self.step_list[x]
                let name = dic.value(forKey: "name") as! String
                let belong = dic.value(forKey: "belong") as! String
                let oldRank = dic.value(forKey: "rank") as! Int
                let times = dic.value(forKey: "times") as! Int
                let counts = dic.value(forKey: "counts") as! Int
                let newRank = oldRank-1
                step.update(name: name, belong: belong, times: times, counts: counts, rank: oldRank, newRank: newRank)
                */
            }
        }
        
        
        //直接更新 将 旧的indexpath 换成 新的 indexpath
        
        dic = self.step_list[sourceRank]
        let name = dic.value(forKey: "name") as! String
        let belong = dic.value(forKey: "belong") as! String
        let oldRank = dic.value(forKey: "rank") as! Int
        let times = dic.value(forKey: "times") as! Int
        let counts = dic.value(forKey: "counts") as! Int
        let newRank = destinationIndexPath.row
        
        step.update(name: name, belong: belong, times: times, counts: counts, rank:oldRank , newRank: newRank)
        //这里每次移动完毕都会自动刷新cell表
        print("移动完毕")
    }
    
    
    //单个压面cell数量
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.frame.height / 6)
    }
    
    //// end tableview ////
    

    
    //MARK pickerview delegate & datasource 
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            //循环次数最多99次
            return 99
        }else  {
            //组间间隔 和循环休息时间不能超过 10分钟， 即6000秒
            return 600
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let showLabel = UILabel()
        if component == 0 {
            showLabel.text = String.init(format: "%1$02d", row)
        }else {
            showLabel.text = String.init(format: "%1$03d", row)
        }
        
        return showLabel
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let showLabel = pickerView.view(forRow: row, forComponent: component) as! UILabel
        if component == 0 {
            showLabel.text = "\(showLabel.text!) 循环次数"
            
        }else if component == 1{
            showLabel.text = "\(showLabel.text!)组间休息"
        }else if component == 2 {
            showLabel.text = "\(showLabel.text!)轮间休息"
        }
    }
    
    
    /// end pickerview
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        if self.doneButton.title == "编辑" {
            //点击编辑
            self.textField.becomeFirstResponder()
            self.doneButton.title = "确定"
        }else {
            //点击确定
            //写入project数据库
            
            self.ProjectLoop = self.thePickerView.selectedRow(inComponent: 0)
            self.ProjectInterval = self.thePickerView.selectedRow(inComponent: 1)
            self.ProjectResttime = self.thePickerView.selectedRow(inComponent: 2)
            let project = PROJECT_LIST()
            project.update(name: self.projectName, interval: self.ProjectInterval!, loop: self.ProjectLoop!, resttime: self.ProjectResttime!)
            //改变显示的数据
            self.loopLabel.text = "循环 \(self.ProjectLoop!) 次"
            self.intervalLabel.text = "组间休息 \(self.ProjectInterval!) 秒"
            self.timesLabel.text = "轮间休息 \(self.ProjectResttime!) 秒"
            
            self.textField.resignFirstResponder()
            self.doneButton.title = "编辑"
            
        }
        
        
    }
    
    
    
    @IBAction func cancleButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func autoButtonPressed(_ sender: Any) {
        print("进入自动模式")
    }
    
    
    @IBAction func manualButtonPressed(_ sender: Any) {
        print("进入手动模式")
    }

    
    
}
