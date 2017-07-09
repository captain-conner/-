//
//  ViewController.swift
//  健身软件
//
//  Created by CaptainSeanConner on 2017/2/24.
//  Copyright © 2017年 $CaptainConner$. All rights reserved.
//





//sqlite 存放路径 /Users/seanconner/Library/Developer/CoreSimulator/Devices/113C8ACE-2EF9-4BC4-8ADD-4C52C98ABDF9/data/Containers/Data/Application/0A6D6DD9-1BC2-47F3-B601-2057BDA5003F/Library/Application Support

import UIKit
import CoreData
//音频库
import AVFoundation

class ViewController: UIViewController,AVAudioPlayerDelegate {

    var player:AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //要设置成全局变量
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        print(path)
        
        
        /*        
        let musicpath = Bundle.main.path(forResource: "are you ready 54321 go", ofType: "wav")
        let url = URL(fileURLWithPath: musicpath!)
        

        
        
        
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setActive(true)
            
            try self.player = AVAudioPlayer(contentsOf: url)
            self.player.delegate = self
            self.player.volume = 0.3
            self.player.prepareToPlay()
            self.player.play()
            
        } catch {
            print("发生错误")
        }
 
         */
        
        //判断是否更新
        
        
        
        let date = Date(timeIntervalSinceNow: 7984)
       
        print(date)
    
  
 
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
        /*
         func auto_anticlockwise() {
         print("开始自动模式 ")
         self.loopLabel.text = "剩下 \(self.loop) 轮"
         
         
         if  self.currentStepTimes > 0{
         self.currentStepTimes -= 1
         setCountDownLabel(theTime: self.currentStepTimes)
         }else {
         //时间到，跳到下一组
         self.timer.invalidate()
         self.currentStep += 1
         //判断该动作是否为最后一组，是否全部动作做完。
         if currentStep < self.step_list.count {
         //还没做完，下一个动作开始
         //组之间 休息 -----------------------
         //这里开始计时休息计时代码
         
         showStepDetail()
         self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.auto_anticlockwise), userInfo: nil, repeats: true)
         }else {
         //是最后一组了 ，循环次数 -1
         self.loop -= 1
         //判断是否为最后一个循环
         print("循环数 \(self.loop)")
         if self.loop > 0 {
         self.currentStep = 0
         showStepDetail()
         self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.auto_anticlockwise), userInfo: nil, repeats: true)
         } else {
         //是最后一组，全部做完。 显示提醒
         print("全部动作做完，显示完全做完的界面")
         showAlert(event: "finish")
         setMusicPlayer(musicName: "10987654321finish")
         self.player.play()
         }
         }
         
         }
         
         }

        */
        
        
        
        /*
         //是否最后一步
         if self.currentStep >= self.step_list.count {
         //是否最后的loop
         if self.currentLoop < self.loop {
         self.currentLoop += 1
         self.statue = "looptime"
         self.currentLoopRestTimes = self.resttime
         } else {
         self.timer.invalidate()
         print("全部做完")
         }
        */
    }

    
}

