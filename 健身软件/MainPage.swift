//
//  MainPage.swift
//  健身软件
//
//  Created by CaptainSeanConner on 2017/3/2.
//  Copyright © 2017年 $CaptainConner$. All rights reserved.
//

import UIKit

class MainPage: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    //scroll 窗口
    @IBOutlet weak var scrollView: UIScrollView!
    var oldOffset:CGPoint!
    var imageView1:UIImageView = UIImageView()
    var imageView2:UIImageView = UIImageView()
    var imageView3:UIImageView = UIImageView()
    var imageView4:UIImageView = UIImageView()
    var imageView5:UIImageView = UIImageView()
    //主页图片信息
    var mainPtoto:[String]!
    //滚动哪一行指定的指针
    var p:Int = 0
    var mark:Int = 0
    var timer:Timer!
    
    var cell_list:[NSDictionary]!
    var chose_project:String!
    var selectedIndexPah:Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //接受控制滚动开始和停止的消息
        NotificationCenter.default.addObserver(self, selector: #selector(self.acceptMessage(message:)), name: NSNotification.Name(rawValue: "StopRollingMainPageNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.acceptMessage(message:)), name: NSNotification.Name(rawValue: "StartRollingMainPageNotification"), object: nil)
        
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        print(path)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reflash), name: NSNotification.Name(rawValue: "AddProjectSuccessNotification"), object: nil)
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    
        //初始化主页图片名称
        self.mainPtoto = ["main0","main1","main2","main3","main4","main5","main6","main7","main8","main9"]
        setCell_Frame()
        
        setScrollViewImage()
        self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.setScrollViewImage), userInfo: nil, repeats: true)
        //let steps = STEP_LIST()
        
        
        
        reflash()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func reflash() {
        let projects = PROJECT_LIST()
        self.cell_list = projects.getPROJECTS()
        self.tableView.reloadData()
    }
    
    func acceptMessage(message:Notification) {
        print("主页面接受到消息")
        print(message.name.rawValue)
        if message.name.rawValue == "StopRollingMainPageNotification" {
            if self.timer.isValid == true {
                self.timer.invalidate()
            }
        }else if message.name.rawValue == "StartRollingMainPageNotification" {
            if self.timer.isValid == false {
                self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.setScrollViewImage), userInfo: nil, repeats: true)
            }
        }
    }

   //MARK -- TableView delegate & datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.cell_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainpage_project", for: indexPath)
        let dic = self.cell_list[indexPath.row]
        cell.textLabel?.text = dic.value(forKey: "name") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "我的计划"
    }
    
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.selectedIndexPah = indexPath.row
        return indexPath
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //删除 project 和 step 表的数据
            let deleteProjectName = (self.cell_list[indexPath.row]).value(forKey: "name") as! String
            let project = PROJECT_LIST()
            project.delete(name: deleteProjectName)
            let step = STEP_LIST()
            let project_steps = step.searchBelong(name: deleteProjectName)
            for eachstep in project_steps {
                let deleteStepName = eachstep.value(forKey: "name") as! String
                let deleteStepRank = eachstep.value(forKey: "rank") as! Int
                step.delete(name: deleteStepName, belong: deleteProjectName, rank: deleteStepRank)
                
            }
            
            self.reflash()
        }
    }
    /////tableview end////////////
    //点击cell 跳转到我的计划
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "user_project" {
            let vc = segue.destination as! UserProject
            
            let dic = self.cell_list[self.selectedIndexPah]
            let name = dic.value(forKey: "name") as! String
            print("======================\(name)")
            vc.projectName = name
            
        }
    }

    
    
    //-------------------滚动相关函数--------------------------------------------------------
    
    
    func chooseRoll_Index() ->Int{
        let fpointer = self.p
        if self.p < self.mainPtoto.count {
            self.p += 1
            return fpointer
        }else {
            self.p = 0
            return 0
        }
    }
    
    //设置cell要显示的图片，然后滚动 ，配合 timer使用。
    //
    func setScrollViewImage() {
        
        let choice = self.chooseRoll_Index()

        
        
        let str = self.mainPtoto[choice]
        print(str)
        self.imageView2.image = UIImage(named: str)
        self.imageView5.image = UIImage(named: str)
        
        
      
        self.imageView3.image = UIImage(named: str)
        
   
        self.imageView4.image = UIImage(named: str)
        self.imageView1.image = UIImage(named: str)
        

        
        //滚动
        if self.mark == 0 {
            self.oldOffset.x = self.oldOffset.x + 375
            
            self.scrollView.setContentOffset(self.oldOffset, animated: true)
            
            self.mark = 1
        }else if self.mark == 1 {
            self.oldOffset.x = self.oldOffset.x + 375
            self.scrollView.setContentOffset(self.oldOffset, animated: true)
            
            self.mark = 2
        }else if self.mark == 2 {
            self.oldOffset.x = self.oldOffset.x - 2*375
            self.scrollView.setContentOffset(self.oldOffset, animated: false)
            
            self.mark = 0
        }
        
        
    }
    
    
    
    
    
    func setCell_Frame() {
        
        
        //初始化cell的组件
        self.imageView1 = UIImageView()
        self.imageView2 = UIImageView()
        self.imageView3 = UIImageView()
        self.imageView4 = UIImageView()
        self.imageView5 = UIImageView()
        
        self.imageView1.contentMode = .scaleAspectFill
        self.imageView2.contentMode = .scaleAspectFill
        self.imageView3.contentMode = .scaleAspectFill
        self.imageView4.contentMode = .scaleAspectFill
        self.imageView5.contentMode = .scaleAspectFill
        
        let scrollerFrame = self.scrollView.frame
        
        
        self.imageView1.frame = scrollView.frame
        //self.imageView1.frame = CGRect(x: cellFrame.origin.x, y: cellFrame.origin.y, width: scrollerFrame.width, height: scrollerFrame.height)
        self.scrollView.addSubview(imageView1)
        
        self.imageView2.frame = CGRect(x: 0+375.0, y: 0, width: scrollerFrame.width, height: scrollerFrame.height)
        self.scrollView.addSubview(imageView2)
        
        self.imageView3.frame = CGRect(x: 0+2*375.0, y: 0, width: scrollerFrame.width, height: scrollerFrame.height)
        self.scrollView.addSubview(imageView3)
        
        self.imageView4.frame = CGRect(x: 0+3*375.0, y: 0, width: scrollerFrame.width, height: scrollerFrame.height)
        self.scrollView.addSubview(imageView4)
        
        self.imageView5.frame = CGRect(x: 0+4*375.0, y: 0, width: scrollerFrame.width, height: scrollerFrame.height)
        self.scrollView.addSubview(imageView5)
        
        self.scrollView.contentSize = CGSize(width: 0+365, height: self.scrollView.frame.height)
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1500) //整个scrillview的范围，这个范围决定了bound
        scrollView.contentSize = scrollView.bounds.size
        
        //初始默认第二张
        
        self.scrollView.contentOffset.x = 375.0
        self.oldOffset = scrollView.contentOffset
        
        self.scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        
        
        
    }
    
    //------------------------END----------------------------------------
    
}
