//
//  MotionCell.swift
//  健身软件
//
//  Created by CaptainSeanConner on 2017/2/27.
//  Copyright © 2017年 $CaptainConner$. All rights reserved.
//

import UIKit

class MotionCell: UITableViewCell,UIScrollViewDelegate {

    //该分类下的图片列表
    var cell_list:[NSDictionary] = [NSDictionary]()
    
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var oldOffset:CGPoint!
    var imageView1:UIImageView = UIImageView()
    var imageView2:UIImageView = UIImageView()
    var imageView3:UIImageView = UIImageView()
    var imageView4:UIImageView = UIImageView()
    var imageView5:UIImageView = UIImageView()
    var mark = 0
    var pointer = 0 //指针位置 0-count-1 之间循环
    
    
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        print("点击了按钮")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    func setCell_Frame(category:String) {
        
        self.categoryLabel.text = category
        //初始化cell的组件
        self.imageView1 = UIImageView()
        self.imageView2 = UIImageView()
        self.imageView3 = UIImageView()
        self.imageView4 = UIImageView()
        self.imageView5 = UIImageView()
        self.scrollView.frame = self.frame
        let scrollerFrame = self.scrollView.frame
        let cellFrame = self.frame
        
        self.imageView1.frame = scrollView.frame
        //self.imageView1.frame = CGRect(x: cellFrame.origin.x, y: cellFrame.origin.y, width: scrollerFrame.width, height: scrollerFrame.height)
        self.scrollView.addSubview(imageView1)
        
        self.imageView2.frame = CGRect(x: 0, y: 0, width: scrollerFrame.width, height: scrollerFrame.height)
        self.scrollView.addSubview(imageView2)
        
        self.imageView3.frame = CGRect(x: 0+1*375.0, y: 0, width: scrollerFrame.width, height: scrollerFrame.height)
        self.scrollView.addSubview(imageView3)
        
        self.imageView4.frame = CGRect(x: 0+2*375.0, y: 0, width: scrollerFrame.width, height: scrollerFrame.height)
        self.scrollView.addSubview(imageView4)
        
        self.imageView5.frame = CGRect(x: 0+3*375.0, y: 0, width: scrollerFrame.width, height: scrollerFrame.height)
        self.scrollView.addSubview(imageView5)
        
        self.scrollView.contentSize = CGSize(width: 0+365, height: self.scrollView.frame.height)
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1500) //整个scrillview的范围，这个范围决定了bound
        scrollView.contentSize = scrollView.bounds.size
        
        //初始默认第二张
        
        self.scrollView.contentOffset.x = cellFrame.origin.x+375.0
        self.oldOffset = scrollView.contentOffset
        
        self.scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        
        print("/////////////cell frame \(self.frame)")
        print("/////////////scroll frame \(self.scrollView.frame)")
        
    }
    
    //最开始的初始化第一张默认cell图片
    func initCellImage() {
        
        
        //设置cell的内部插件位置和大小
        
        
        let counter = self.cell_list.count
        
        
        var str = NSDictionary()
        
        //
        print(self.pointer)
        str = self.cell_list[self.pointer]
        print(str.value(forKey: "name") as! String)
        self.imageView2.image = UIImage(named: str.value(forKey: "name") as! String)
        self.imageView5.image = UIImage(named: str.value(forKey: "name") as! String)
        
        
        if self.pointer == counter - 1 {
            self.pointer = 0
        }else {
            self.pointer += 1
        }
        print(self.pointer)
        str = self.cell_list[self.pointer]
        print(str.value(forKey: "name") as! String)
        self.imageView3.image = UIImage(named: str.value(forKey: "name") as! String)
        
        if self.pointer == counter - 1 {
            self.pointer = 0
        }else {
            self.pointer += 1
        }
        print(self.pointer)
        str = self.cell_list[self.pointer]
        print(str.value(forKey: "name") as! String)
        self.imageView4.image = UIImage(named: str.value(forKey: "name") as! String)
        self.imageView1.image = UIImage(named: str.value(forKey: "name") as! String)
        
        if self.pointer == counter - 1 {
            self.pointer = 0
        }else {
            self.pointer += 1
        }
        
        
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
    
}
