//
//  SelectMotionController.swift
//  健身软件
//
//  Created by CaptainSeanConner on 2017/3/5.
//  Copyright © 2017年 $CaptainConner$. All rights reserved.
//

import UIKit

class SelectMotionController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var category_tableview: UITableView!
    
    @IBOutlet weak var list_tableView: UITableView!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var category_list:[String] = [String]()
    var list:[NSDictionary] = [NSDictionary]()
    var selectedCategory:String!
    var selectedMotion:Int!
    var hasRotete:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.category_tableview.delegate = self
        self.category_tableview.dataSource = self
        //对分类表进行旋转
        //逆时针旋转 90°
        let cframe = self.category_tableview.frame
        self.category_tableview.transform = self.category_tableview.transform.rotated(by: CGFloat(-M_PI/2))
        //self.category_tableview.frame = CGRect(x: cframe.origin.x, y: cframe.origin.y, width: self.list_tableView.frame.width, height: cframe.height)
        self.category_tableview.frame = CGRect(x: cframe.origin.x, y: cframe.origin.y, width: self.list_tableView.frame.width-30, height: 70)
        
        self.list_tableView.delegate = self
        self.list_tableView.dataSource = self
        
        
        
        
        let motion = MOTION_LIST()
        let dics = motion.getMotions()
        for x in dics {
            let str =  x.value(forKey: "category") as! String
            if self.category_list.contains(str) == false {
                self.category_list.append(str)
            }
        }
        
        print(self.category_list)
        
        self.selectedCategory = self.category_list[0]
        self.list = motion.searchProperty(propertyName: "category", propertyValue: self.category_list[0])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK -- tableview delegate & datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 0 {
            return (self.list_tableView.frame.width / 4 )
        }else {
            return (tableView.frame.height / 6)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return self.category_list.count
        }else {
            return self.list.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            let cell = self.category_tableview.dequeueReusableCell(withIdentifier: "cate", for: indexPath)
            cell.textLabel?.frame = cell.frame
            cell.textLabel?.text =  self.category_list[indexPath.row]
            cell.textLabel?.textAlignment = .center
            cell.backgroundColor = UIColor.black
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            
            cell.textLabel?.textColor = UIColor.white
           
            //判断不会让其一直旋转
            if cell.transform == self.list_tableView.transform {
                //cell 旋转
                cell.transform = cell.transform.rotated(by: CGFloat(M_PI/2))
            }
            
            return cell
        } else {
            
            let cell = self.list_tableView.dequeueReusableCell(withIdentifier: "list", for: indexPath) as! SelectListCell
            let motion = MOTION_LIST()
            self.list = motion.searchProperty(propertyName: "category", propertyValue: self.selectedCategory)
            let dic = self.list[indexPath.row]
            let name = dic.value(forKey: "name") as! String
            print("name 复制给cell \(name)")
            //cell.name = name
            //cell.textLabel?.text = name
            //cell.imageView?.frame = cell.frame
            //cell.imageView?.image = UIImage(named: name)
            cell.setting(name: name,dic:dic,controller: self)
            return cell
 
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if tableView.tag == 0 {
            print("选择了类型栏")
            self.selectedCategory = self.category_list[indexPath.row]
            let motion = MOTION_LIST()
            self.list = motion.searchProperty(propertyName: "category", propertyValue: self.selectedCategory)
            self.list_tableView.reloadData()
        }
        
        
        if tableView.tag == 1 {
            self.selectedMotion = indexPath.row
        }
        return indexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //addProject_showdetail
        if segue.identifier == "addProject_showdetail" {
            let vc = segue.destination as! AddMotion
            /*
            let motion = MOTION_LIST().searchProperty(propertyName: "category", propertyValue: self.category_list[self.selectedMotion])
            let dic = motion[self.selectedMotion]
             */
            let dic = self.list[self.selectedMotion]
            
            let name = dic.value(forKey: "name")as! String
            let detail = dic.value(forKey: "detail") as! String
            //vc.setting(name: name, belong: "计划名称",detail: detail)
            vc.name = name
            vc.detail = detail
            vc.belong = "计划名称"
           
        }
    }
}
