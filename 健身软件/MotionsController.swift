//
//  MotionsController.swift
//  健身软件
//
//  Created by CaptainSeanConner on 2017/2/27.
//  Copyright © 2017年 $CaptainConner$. All rights reserved.
//

import UIKit


//问题： 滚动出现的点状况，第二个cell不能实现滚动，现在先搁置，不做滚动功能

class MotionsController: UITableViewController {
    
    
    
    
    //运动种类的列表
    var cell_category:[String] = [String]()
    var choseMotion_list:[NSDictionary] = [NSDictionary]()
 
    //滚动计时器
    var timer:Timer!
    //滚动哪一行指定的指针
    var p:Int = 0

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        print(path)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.stopRolling), name: NSNotification.Name(rawValue: "StopRollingMotionsControllerNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.startRolling), name: NSNotification.Name(rawValue: "StartRollingMotionsControllerNotification"), object: nil)
        
        
        
        let motions = MOTION_LIST().getMotions()
        for motion in motions {
            let str = motion.value(forKey: "category") as! String
            if cell_category.contains(str) == false {
                self.cell_category.append(str)
            }
        }
        print(self.cell_category)
        
        //计时滚动
        self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.setScrollViewImage), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    //关闭本页面的申请
    func stopRolling() {
        print("接受到停止滚动的消息")
        if self.timer.isValid == true {
            self.timer.invalidate()
        }
        
    }
    func startRolling() {
        print("接受到开始滚动的消息")
        if self.timer.isValid == false {
            self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.setScrollViewImage), userInfo: nil, repeats: true)
        }

    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.cell_category.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "motion_cell", for: indexPath) as! MotionCell
        
        cell.cell_list = MOTION_LIST().searchProperty(propertyName: "category", propertyValue: self.cell_category[indexPath.row])
        cell.setCell_Frame(category:cell_category[indexPath.row])
        cell.initCellImage()
        print("cell for row")
        
        return cell
    }
    
    //将要显示cell所做的动作。
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        print("will display")
    }
    
    //设置table可以显示4个cell  大小设置成固定的类型
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.tableView.frame.size.height / 7
    }
    
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print("willselect\(indexPath.row)")
        
        let motion = MOTION_LIST()
        
        let category = motion.searchProperty(propertyName: "category", propertyValue: self.cell_category[indexPath.row])
        self.choseMotion_list = category
        
        setScrollViewImage()
        print("=====================select 了 \(indexPath.row) 行")
        for x in self.choseMotion_list {
            print(x.value(forKey: "name")!)
        }

        return indexPath
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print("did selected")

        
    }
    
    

    //跳转前传递数据
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare for")
        print("开始跳转到二级cell ")
        if segue.identifier == "category_detail" {
            //先停止滑动
            if self.timer.isValid == true {
                self.timer.invalidate()
            }
            
            let vc = segue.destination as! MotionDetailList
            vc.cell_list = self.choseMotion_list
            for x in vc.cell_list {
                print(x.value(forKey: "name")!)
            }
        }
        
    }
    
    //检测tableview是否在滑动
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("talbeview已经在滑动")
    }
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("talbeview已经在滑动准备滑动")
        //滑动之前发送停止滚动的消息。。。
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StopRollingMotionsControllerNotification"), object: nil, userInfo: nil)
    }
    
    //-------------------滚动相关函数--------------------------------------------------------
    
    //根据category选择该哪一个cell 滚动 循环返回 int
    func chooseRoll_Index() ->Int{
        let fpointer = self.p
        if self.p < self.cell_category.count {
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
        print("开始滚 ---------------\(choice)")
      
        
        let cell = self.tableView.cellForRow(at: IndexPath(row: choice, section: 0)) as! MotionCell
        
        
        //设置cell的内部插件位置和大小
        
        
        
        let counter = cell.cell_list.count
        
        
        var str = NSDictionary()
        
        //
        print(cell.pointer)
        str = cell.cell_list[cell.pointer]
        print(str.value(forKey: "name") as! String)
        cell.imageView2.image = UIImage(named: str.value(forKey: "name") as! String)
        cell.imageView5.image = UIImage(named: str.value(forKey: "name") as! String)
        
        
        if cell.pointer == counter - 1 {
            cell.pointer = 0
        }else {
            cell.pointer += 1
        }
        print(cell.pointer)
        str = cell.cell_list[cell.pointer]
        print(str.value(forKey: "name") as! String)
        cell.imageView3.image = UIImage(named: str.value(forKey: "name") as! String)
        
        if cell.pointer == counter - 1 {
            cell.pointer = 0
        }else {
            cell.pointer += 1
        }
        print(cell.pointer)
        str = cell.cell_list[cell.pointer]
        print(str.value(forKey: "name") as! String)
        cell.imageView4.image = UIImage(named: str.value(forKey: "name") as! String)
        cell.imageView1.image = UIImage(named: str.value(forKey: "name") as! String)
        
        if cell.pointer == counter - 1 {
            cell.pointer = 0
        }else {
            cell.pointer += 1
        }
        
        
        //滚动
        if cell.mark == 0 {
            cell.oldOffset.x = cell.oldOffset.x + 375
            
            cell.scrollView.setContentOffset(cell.oldOffset, animated: true)
            
            cell.mark = 1
        }else if cell.mark == 1 {
            cell.oldOffset.x = cell.oldOffset.x + 375
            cell.scrollView.setContentOffset(cell.oldOffset, animated: true)
            
            cell.mark = 2
        }else if cell.mark == 2 {
            cell.oldOffset.x = cell.oldOffset.x - 2*375
            cell.scrollView.setContentOffset(cell.oldOffset, animated: false)
            
            cell.mark = 0
        }

        
    }
    
    //------------------------END----------------------------------------
    
  
}
