//
//  AutoOrManual_StartProject.swift
//  健身软件
//
//  Created by CaptainSeanConner on 2017/3/3.
//  Copyright © 2017年 $CaptainConner$. All rights reserved.
//

import UIKit
import AVFoundation
class AutoOrManual_StartProject: UIViewController,AVAudioPlayerDelegate {

    @IBOutlet weak var theImage: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    //循环次数
    @IBOutlet weak var loopLabel: UILabel!
    //倒计时标题
    @IBOutlet weak var countDownLabel: UILabel!
   
    //每个动作的次数
    @IBOutlet weak var countLabel: UILabel!
    
    //最下方 开始和暂停按钮，不是计时的开始
    @IBOutlet weak var start_and_pause_Button: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    //左上方返回按钮
    @IBOutlet weak var cancleButton: UIBarButtonItem!
    
    //顺数计时按钮 和 时间复位annual
    @IBOutlet weak var startCountDownButton: UIButton!
    @IBOutlet weak var resetTimeButton: UIButton!
    //顺数计时标题
     @IBOutlet weak var timeLabel: UILabel!
    
    //音乐播放变量
    var player:AVAudioPlayer = AVAudioPlayer()
    var session = AVAudioSession.sharedInstance()
    
    
    //休息间隔 循环次数 休息时间
    var interval:Int = 0
    
    var loop:Int = 0
    var resttime:Int = 0

    //自动计时的状态
    var statue:String!
    @IBOutlet weak var statueLabel: UILabel!
    //进行到第几步
    var currentStep:Int = 0
    //进行到第几个循环
    var currentLoop:Int = 0
    
    //步骤时间 间隔休息时间 循环休息时间
    var currentStepCount:Int!
    var currentStepTimes:Int = 0
    var currentIntervalTimes:Int = 0
    var currentLoopRestTimes:Int = 0
    var hour:Int = 0
    var min:Int = 0
    var sec:Int = 0
    //模式
    var mode:String!
    
    var step_list:[NSDictionary] = [NSDictionary]()
    //是否运行项目中，用在cancle button 上
    var IsRunning:Bool = false
    var startStep:Bool = true
    var timer:Timer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //next 按钮一直都是隐藏的， 知道手动模式中点击了开始。
        
        if mode == "manual" {
            self.nextButton.isHidden = false
            self.start_and_pause_Button.isHidden = true
            //self.loopLabel.isHidden = true
            self.countDownLabel.isHidden = true
            self.statueLabel.text = "手动模式中..."

        } else {
            //auto状态
            
            self.statue = "steptime"
            self.nextButton.isHidden = true
            self.startCountDownButton.isHidden = true
            self.timeLabel.isHidden = true
            self.resetTimeButton.isHidden = true
            self.statueLabel.text = "等待开始..."
        }
        
        
        //初始化
        //默认显示 第一个动作
        showStepDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //根据音乐名字设置 播放的音乐
    func setMusicPlayer(musicName:String) {
        
        do {
            
            let music_path = Bundle.main.path(forResource: musicName, ofType: "wav")
            let music_url = URL(fileURLWithPath: music_path!)
            
            //let session = AVAudioSession.sharedInstance()
            //try session.setActive(true)
            
            try self.player = AVAudioPlayer(contentsOf: music_url)
            self.player.delegate = self
            //self.player.delegate = self
            self.player.volume = 0.3
            self.player.prepareToPlay()
            
           
            
        } catch {
            print("发生错误")
        }
    }
    
    //根据currentstep 初始化 和显示 每一步的数据
    func showStepDetail(isZero:Bool=false) {
        let step_dic = self.step_list[self.currentStep]
        let currentStepName = step_dic.value(forKey: "name") as! String
        self.theImage.image = UIImage(named: currentStepName)
        
        if self.mode == "auto" {
            //判断是否数到零了。
            if isZero == true {
                setCountDownLabel(theTime: 0)
            }else {
                setCountDownLabel(theTime: step_dic.value(forKey: "times") as! Int)
            }
            
        }
        
        
        self.countLabel.text =  "动作次数 X\(step_dic.value(forKey: "counts")!)"
        self.currentStepCount = step_dic.value(forKey: "counts") as! Int!
        self.currentStepTimes = step_dic.value(forKey: "times") as! Int!
        let motion = MOTION_LIST()
        let motion_dic = motion.searchProperty(propertyName: "name", propertyValue: currentStepName)[0]
        self.textView.text = motion_dic.value(forKey: "detail") as? String
        
        
    }
    
    
    //负责设置倒计时显示的函数
    func setCountDownLabel(theTime:Int) {
        
        self.hour = Int(theTime/3600)
        self.min = Int((theTime - hour*3600)/60)
        self.sec = Int((theTime - hour*3600 - min*60))
        
        print("times\(theTime)  \(self.hour) :\(self.min) :\(self.sec)")
        let str = String.init(format:"%1$02d:%2$02d:%3$02d",self.hour,self.min,self.sec)
        self.countDownLabel.text = str
    }
    
    //左上角
    @IBAction func cancleButtonPressed(_ sender: Any) {
        if self.IsRunning == true {
            showAlert(event: "out")
        }else {
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
  
    // manual 模式下 计时 开始和暂停按钮
    @IBAction func countDownButtonPressed(_ sender: Any) {
        print("点击了计时器的按钮")
        if self.startCountDownButton.titleLabel?.text == "开始" {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.clockwise), userInfo: nil, repeats: true)
            self.startCountDownButton.setTitle("暂停", for: .normal)
            self.startCountDownButton.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            self.timer.invalidate()
            self.startCountDownButton.setTitle("开始", for: .normal)
            self.startCountDownButton.setImage(UIImage(named: "start"), for: .normal)
        }
    }
    //复位按钮
    @IBAction func resetButtonPressed(_ sender: Any) {
        self.hour = 0
        self.min = 0
        self.sec = 0
        self.timeLabel.text = "00:00:00"
        if self.timer.isValid == true {
            self.timer.invalidate()
        }
        
        self.startCountDownButton.setTitle("开始", for: .normal)
        self.startCountDownButton.setImage(UIImage(named: "start"), for: .normal)
    }
    

    //开始和暂停按钮
    @IBAction func start_and_pause_ButtonPressed(_ sender: Any) {
        print("点击了开始或暂停按钮")
        
        
        self.IsRunning = true
        if self.start_and_pause_Button.titleLabel?.text == "开始" {
            //判断模式 调用不同的倒计时方法
            if self.mode == "auto" {
                //自动模式
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.auto_anticlockwise), userInfo: nil, repeats: true)
                
            }else {
                //手动模式
                self.nextButton.isHidden = false
                
            }
            self.start_and_pause_Button.setTitle("暂停", for: .normal)
            self.startCountDownButton.setImage(UIImage(named: "pause"), for: .normal)
            
        }else{
            self.timer.invalidate()
            self.start_and_pause_Button.setTitle("开始", for: .normal)
            self.startCountDownButton.setImage(UIImage(named: "start"), for: .normal)
        }
    }
    //下一组按钮
    @IBAction func next_ButtonPressed(_ sender: Any) {
        
        print("点击了下一组按钮")
        self.IsRunning = true
        //复位一下 manual模式下的时间
        self.hour = 0
        self.min = 0
        self.sec = 0
        self.timeLabel.text = "00:00:00"
        if self.timer != nil {
            self.timer.invalidate()
        }
        
        if self.mode == "auto" {
            self.startCountDownButton.setTitle("开始", for: .normal)
            self.startCountDownButton.setImage(UIImage(named: "start"), for: .normal)
            if self.nextButton.titleLabel?.text == "下一组" {
                if self.currentStep < self.step_list.count-1 {
                    self.currentStep += 1
                    showStepDetail()
                    if self.currentStep >= self.step_list.count-1 {
                        self.nextButton.setTitle("完成", for: .normal)
                        
                    }
                }
            }else {
                showAlert(event: "finish")
                
            }
        }
        
        if self.mode == "manual" {
            if self.nextButton.titleLabel?.text == "下一组" {
                if self.currentStep == self.step_list.count-1 {
                    //完成了最后一步
                    self.nextButton.setTitle("完成", for: .normal)
                    self.startCountDownButton.setImage( UIImage(named: "start"), for: .normal)
                    self.startCountDownButton.setTitle("开始", for: .normal)
                    
                }else {
                    self.currentStep += 1
                    self.startCountDownButton.setImage( UIImage(named: "start"), for: .normal)
                    self.startCountDownButton.setTitle("开始", for: .normal)
                    showStepDetail()
                }
            }else {
                //self.nextButton.titleLabel?.text == "完成"
                showAlert(event: "finish")
            }
        }
        
    }
    
    
    //Auto模式的倒计时方法
    func auto_anticlockwise() {
        print("开始自动模式 ")
        //三种状态  1 steptime 2 intervaltime 3 looptime
        self.loopLabel.text = "还剩 \(self.loop - self.currentLoop)轮"
        
        switch self.statue {
        case "steptime":
            
            print("steptime")
            //判断是不是开始step，音乐只是开始的时候响
            if self.startStep == true {
                setMusicPlayer(musicName: "321go")
                self.player.play()
                while self.player.isPlaying == true {
                    
                }
                self.startStep = false
            }
            
            
            self.statueLabel.text = "运动中..."
            setCountDownLabel(theTime: self.currentStepTimes)
            if self.currentStepTimes != 0 {
                //防止显示-1的情况
                self.currentStepTimes -= 1
            }
            
            setCountDownLabel(theTime: self.currentStepTimes)
            //是否没有时间
            print("是否没有时间")
            if self.currentStepTimes == 0 {
                showStepDetail(isZero: true)
                //是否最后一步
                print("是否最后一步")
                if self.currentStep == self.step_list.count-1 {
                    //是最后一步，接着判断是否最后的loop
                    print("是最后一步，接着判断是否最后的loop")
                    if self.currentLoop == self.loop-1 {
                        //是最后loop全部做完
                        print("是最后loop全部做完")
                        self.timer.invalidate()
                        setMusicPlayer(musicName: "10987654321finish")
                        self.player.play()
                        while self.player.isPlaying == true {
                            
                        }
                        showAlert(event: "finish")
                    }else {
                        //不是最后loop重新调到step开头,开始loop休息
                        print("//不是最后loop重新调到step开头,开始loop休息")
                        setMusicPlayer(musicName: "321 brake")
                        self.player.play()
                        while self.player.isPlaying == true {
                            
                        }
                        
                        self.currentStep = 0
                        showStepDetail(isZero: true)
                        self.currentLoop += 1
                        self.statue = "looptime"
                        self.currentLoopRestTimes = self.resttime
                        
                        
                    }
                }else {
                    //跳到下一步,然后intelval休息
                    print("跳到下一步,然后intelval休息")
                    setMusicPlayer(musicName: "321 brake")
                    self.player.play()
                    while self.player.isPlaying == true {
                        
                    }
                    
                    self.currentStep += 1
                    self.statue = "intervaltime"
                    self.currentIntervalTimes = self.interval
                    
                    
                    
                }
            }else {
                
            }
        case "intervaltime":
            print("intarval time \(self.currentIntervalTimes)")
            self.statueLabel.text = "间隔休息中..."
            setCountDownLabel(theTime: self.currentIntervalTimes)
            if self.currentIntervalTimes != 0 {
                self.currentIntervalTimes -= 1
            }
            
            setCountDownLabel(theTime: self.currentIntervalTimes)
            //是否intervaltime没时间
            print("是否intervaltime没时间")
            if self.currentIntervalTimes == 0 {
                    //如果没时间,则直接跳到下一个点
                print("没时间,则直接跳到下一个step点")
                self.currentIntervalTimes = self.interval
                self.statue = "steptime"
                showStepDetail(isZero: true)
                self.startStep = true
            }
            
        case "looptime":
            print("loop rest time \(self.currentLoop) \(currentLoopRestTimes)")
            self.statueLabel.text = "循环休息中..."
            setCountDownLabel(theTime: self.currentLoopRestTimes)
            if self.currentLoopRestTimes != 0 {
                self.currentLoopRestTimes -= 1
            }
            
            setCountDownLabel(theTime: self.currentLoopRestTimes)
            print("是否没有loop时间")
            if self.currentLoopRestTimes == 0 {
                print("没有loop时间，跳到step")
                self.currentLoopRestTimes = self.loop
                self.statue = "steptime"
                showStepDetail(isZero: true)
                self.startStep = true
            }
            
        default: break
            
        }
    }
    
    
    
    
    
    
    
    //提示画面。两种情况 1.全部动作做完，提示完成所有动作 2 左上角 强制结束，弹出确定提示
    func showAlert(event:String) {
        
        if event == "finish" {
            
            let alertController = UIAlertController(title: "well done！！", message: "你已经完成计划！", preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .default, handler: {
                action in
                //点击确定后跳转到前一个界面
                self.IsRunning = false
                self.dismiss(animated: true, completion: nil)
            })
            
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }else {
            //强制结束
            //先停止所有正在运行的计时器
            if self.timer.isValid == true {
                self.timer.invalidate()
            }
            
            let alertController = UIAlertController(title: "强制结束提醒", message: "是否强制结束训练？", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "确定", style: .default, handler: {
                action in
                self.dismiss(animated: true, completion: nil)
            })
            let action2 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertController.addAction(action1)
            alertController.addAction(action2)
            self.present(alertController, animated: true, completion: nil)
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
        
        self.hour = (self.hour + step3) % 60
        //字符串的格式化方法
        self.timeLabel.text = String.init(format: "%3$02d:%2$02d:%1$02d",self.sec,self.min,self.hour)
    }

    
    //avdutio player deletage
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("音乐播放完毕==================")
        do {
            print("继续播放其他音乐")
            try self.session.setActive(false, with: .notifyOthersOnDeactivation)
        } catch {
            print("不能回复其他音乐的播放")
        }
    }
}
