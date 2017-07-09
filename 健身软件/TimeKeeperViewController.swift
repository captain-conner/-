//
//  TimeKeeperViewController.swift
//  健身软件
//
//  Created by CaptainSeanConner on 2017/2/24.
//  Copyright © 2017年 $CaptainConner$. All rights reserved.
//

import UIKit
import  AVFoundation
//时钟，具有顺数和倒数功能
class TimeKeeperViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate {
    

    @IBOutlet weak var clockImage: UIImageView!
    //segment 控制栏
    @IBOutlet weak var segment: UISegmentedControl!
    
    //倒数器组件
    @IBOutlet weak var theTableView: UITableView!


    
    //顺数器组件
    @IBOutlet weak var clockwise_Label: UILabel!
    
    
    @IBOutlet weak var clockwise_Start_and_Pause_Button: UIButton!
    
    @IBOutlet weak var clockwise_reset_Button: UIButton!

    
    var cell_list:[NSDictionary] = [NSDictionary]()
    
    var selectedIndex:Int!
    
    //音乐播放器相关
    var player:AVAudioPlayer!
    let session = AVAudioSession.sharedInstance()
    let musicloop:Bool = true //循环播放标志，控制是否循环播放。
    
    var timer:Timer!
    //顺时针
    //hour:min:sec 99:59:59
    var hours:Int = 0
    var min:Int = 0
    var sec:Int = 0
    
    //逆时针
    var anticlockwiser:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("初始化timekeeper")
                
        //注册接受消息服务, 这里有两个，1 添加闹钟 2.倒计时时间到了
        NotificationCenter.default.addObserver(self, selector: #selector(self.addTime(notification:)), name: NSNotification.Name(rawValue: "TimeHasAddNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.timesUp(notification:)), name: NSNotification.Name(rawValue: "TimesUpNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.timeChange(notification:)), name: NSNotification.Name(rawValue: "TimesChangeNotification"), object: nil)
        
        //判断segment的状态
        if self.segment.selectedSegmentIndex == 0 {
            self.clockwise_Label.isHidden = true
            self.clockwise_Start_and_Pause_Button.isHidden = true
            self.clockwise_reset_Button.isHidden = true
        }
        
        
        
        //初始化组件状态
        //获取timerkeeper内容(自定义方法）
        
        //隐藏多余的tableview行
        self.theTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        refreshTableView()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func segmentValueChange(_ sender: Any) {
        
        if self.segment.selectedSegmentIndex == 1 {
            self.clockwise_Label.isHidden = false
            self.clockwise_Start_and_Pause_Button.isHidden = false
            self.clockwise_reset_Button.isHidden = false
            self.theTableView.isHidden = true
            self.clockImage.isHidden = false
        } else {
            self.clockwise_Label.isHidden = true
            self.clockwise_Start_and_Pause_Button.isHidden = true
            self.clockwise_reset_Button.isHidden = true
            self.theTableView.isHidden = false
            self.clockImage.isHidden = true
        }

    }
    
    //从数据库获取时钟内容，以便tableview 刷新
    func refreshTableView() {
        
        let SQL_time_list = TIMEKEEPER_LIST()
        self.cell_list = SQL_time_list.getTIMEKEEPER()
        print("刷新tableview，cell数量：\(self.cell_list.count)")
        self.theTableView.reloadData()
        
    }

    @IBAction func clockwiseButtonPress(_ sender: Any) {
        
        if self.clockwise_Start_and_Pause_Button.tag == 0 {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.clockwise), userInfo: nil, repeats: true)
            print("点击了开始按钮")
            self.clockwise_Start_and_Pause_Button.tag = 1
            self.clockwise_Start_and_Pause_Button.setImage(UIImage(named: "pause.png"), for: .normal)
            
        } else {
            
            print("点击了暂停按钮")
            self.clockwise_Start_and_Pause_Button.tag = 0
            self.clockwise_Start_and_Pause_Button.setImage(UIImage(named: "start.png"), for: .normal)
            self.timer.invalidate()
        }

    }
    
    
    @IBAction func clockwise_resetButtonPress(_ sender: Any) {
        
        
        if self.timer != nil {
            self.timer.invalidate()
        }
        
        self.hours = 0
        self.min = 0
        self.sec = 0
        self.clockwise_Label.text = "00:00:00"
        if self.clockwise_Start_and_Pause_Button.tag == 1 {
            self.clockwise_Start_and_Pause_Button.tag = 0
            self.clockwise_Start_and_Pause_Button.setImage(UIImage(named: "start.png"), for: .normal)
        }
    }
    

    
    
    //MARK -- tableviewDelegate and DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cell_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = self.theTableView.dequeueReusableCell(withIdentifier: "timer_cell", for: indexPath) as! timerCell
        let dic = cell_list[indexPath.row]
        print("cell-----\(dic.value(forKey: "name")) \(dic.value(forKey: "times"))")
        //初始化每个cell
        cell.nameLabel.text = dic.value(forKey: "name") as! String?
        let times = dic.value(forKey: "times") as! Int
        let hour = Int(times/3600)
        let min = Int((times - hour*3600)/60)
        let sec = Int((times - hour*3600 - min*60))
        cell.cellTime = times
        cell.timesLabel.text = String.init(format: "%1$02d:%2$02d:%3$02d",hour,min,sec)
        return cell
    }
    

    
    
    //设置是否能编辑
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //左划删除显示的文字
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    //删除动作提交
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let SQL_time_list = TIMEKEEPER_LIST()
        let dic = cell_list[row]
        
        SQL_time_list.delete(name: dic.value(forKey: "name") as! String)
        
        refreshTableView()
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.selectedIndex = indexPath.row
        return indexPath
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "timeDetail" {
            let vc = segue.destination as! timeDetail
            let dic = self.cell_list[self.selectedIndex]
            let name = dic.value(forKey: "name") as! String
            let times = dic.value(forKey: "times") as! Int
            vc.initView(timeName: name, times: times)
        }
    }
    
    //顺数功能
    func clockwise() {
        //步进
        //let str = String.init(format: "%1$02d",11)
       
        var step1 = 0
        var step2 = 0
        var step3 = 0
        step1 = Int((self.sec + 1)/60)
        self.sec = (self.sec + 1) % 60
        
        step2 = Int((self.min + step1)/60)
        self.min = (self.min + step1) % 60
        
        step3 = Int((self.min + step2)/60)
        self.min = (self.min + step2) % 60
       
        self.hours = (self.hours + step3) % 60
       //字符串的格式化方法
        self.clockwise_Label.text = String.init(format: "%3$02d:%2$02d:%1$02d",self.sec,self.min,self.hours)
    }
    
    

    
    
    //添加时钟的消息处理
    func addTime(notification:Notification) {
            print("接受到返回消息")
        
        let t = notification.object as! AddTimer
        let hour:Int32 = t.hour
        let min:Int32 = t.min
        let sec:Int32 = t.sec
        let str = t.nameTextField.text
        
        print("接受到的信息：------------------------ \(hour) \(min) \(sec) \(str)")
        let SQL_time_list = TIMEKEEPER_LIST()
        let times:Int32 = sec + min * 60 + hour * 3600
        print("times \(times)")
        SQL_time_list.insert(name: str!, times: times)
        refreshTableView()
        
    }
    
    func timesUp(notification:Notification) {
        
        //播放提醒音乐
       
        let musicpath = Bundle.main.path(forResource: "alarm", ofType: "mp3")
        let url = URL(fileURLWithPath: musicpath!)
        do {
            
            try session.setActive(true)
            
            try self.player = AVAudioPlayer(contentsOf: url)
            self.player.delegate = self
            self.player.volume = 0.3
            self.player.prepareToPlay()
            self.player.play()
            
        } catch {
            print("播放音乐失败")
        }
        ///
        let alertController = UIAlertController(title: "", message: "时间到", preferredStyle:.alert)
        let alertAcrion = UIAlertAction(title: "确定", style: .default, handler: {
            action in
            self.player.stop()
            //如果不循环，即已经可以停止播放，则直接回复其他软件的音乐声音
            do {
                print("继续播放其他音乐")
                try self.session.setActive(false, with: .notifyOthersOnDeactivation)
            } catch {
                print("不能回复其他音乐的播放")
            }
        })
        alertController.addAction(alertAcrion)
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    //收到上一级页面中时间改变的消息
    func timeChange(notification:Notification) {
        print("收到改变时间的消息")
        let dic = NSDictionary(dictionary: notification.userInfo!)
        let name = dic.value(forKey: "name") as! String
        let times = dic.value(forKey: "times") as! Int
        let timekeeper = TIMEKEEPER_LIST()
        timekeeper.update(name: name, times: Int32(times))
        self.refreshTableView()
    }

    //音乐播放器中的方法
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if self.musicloop == true {
            
            let musicpath = Bundle.main.path(forResource: "alarm", ofType: "mp3")
            let url = URL(fileURLWithPath: musicpath!)
            do {
                
                try session.setActive(true)
                
                try self.player = AVAudioPlayer(contentsOf: url)
                self.player.delegate = self
                self.player.volume = 0.3
                self.player.prepareToPlay()
                self.player.play()
                
            } catch {
                print("播放音乐失败")
            }
        }
    }
}
