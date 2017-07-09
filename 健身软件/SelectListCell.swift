//
//  SelectListCell.swift
//  健身软件
//
//  Created by CaptainSeanConner on 2017/3/5.
//  Copyright © 2017年 $CaptainConner$. All rights reserved.
//

import UIKit

class SelectListCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var theImageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    
    
    var name:String!
    var level:Int!
    var cell_dic:NSDictionary!
    var rootController:SelectMotionController!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
 

    @IBAction func addButtonPressed(_ sender: Any) {
        
        print("点击了添加按钮")
        //将默认动作 添加到 上一层的表中 默认的 次数0 时间0
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AddMotionToProject"), object: nil, userInfo: ["name":self.name,"times":0,"counts":0])
        self.rootController.dismiss(animated: true, completion: nil)
        
    }
    
    func setting(name:String,dic:NSDictionary,controller:SelectMotionController) {
        print("初始化 cell 内容")
        //self.theImageView.frame = self.frame
        //self.theImageView.frame = self.frame
        //设置根控制器， 用于cell 响应addbutton action用来关闭当前画面
        self.rootController = controller
        self.cell_dic = dic
        self.name = name
        
        print("name : \(self.name)")
        self.nameLabel.text = self.name
        self.levelLabel.text = "\(level)"
        self.textLabel?.backgroundColor = UIColor.clear
        self.theImageView.image = UIImage(named: name)
        
        
    }
    

    
    
}
