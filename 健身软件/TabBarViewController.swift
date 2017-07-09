//
//  TabBarViewController.swift
//  健身软件
//
//  Created by CaptainSeanConner on 2017/2/25.
//  Copyright © 2017年 $CaptainConner$. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //设置不锁屏
        UIApplication.shared.isIdleTimerDisabled = true

        
        for item in self.tabBar.items!{
            item.image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        }
        //负责数据更新的功能。通过document文件夹下的sqlite数据库，将数据写入默认的数据库
        // 步骤 bundle-》copy to document -》读取document 中db -》插入 默认db。
        //只导入一次，如果已经导入，则不需要再重复上面步骤
        
        
        
        let source_SqlPath = Bundle.main.path(forResource: "source", ofType: "sqlite")!
        print("source_SqlPath \(source_SqlPath)")
        let dest_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let destination = "\(dest_path)/source.sqlite"
        
        
        let fileMaanager = FileManager.default
        //先判断是否已经将外部数据库导入了，如果导入了，就不用再导入了。
        if fileMaanager.fileExists(atPath: destination) == false {
            do{
                print("开始复制 bundle-----to----> document ")
                try fileMaanager.copyItem(atPath: source_SqlPath, toPath: destination)
            }catch {
                print("复制失败")
            }
            
            
            
            if fileMaanager.fileExists(atPath: destination) == true {
                print("数据更新库源文件文件存在")
                
                //指针
                var db:OpaquePointer? = nil
                let state = sqlite3_open(destination, &db)
                
                
                if state == SQLITE_OK {
                    print("数据库打开成功")
                }
                
                
                let sqlstr = "SELECT * FROM ZMOTIONS;"
                //sqlite3_stmt指针
                var stmt:OpaquePointer? = nil
                let cSql = sqlstr.cString(using: .utf8)
                
                //编译
                let prepare_result = sqlite3_prepare_v2(db, cSql!, -1, &stmt, nil)
                
                if prepare_result != SQLITE_OK {
                    sqlite3_finalize(stmt)
                    if (sqlite3_errmsg(db)) != nil {
                        let msg = "SQLiteDB - failed to prepare SQL:\(sqlstr)"
                        print(msg)
                    }
                }
                
                
                
                let m = MOTION_LIST()
                //遍历搜索结果
                while (sqlite3_step(stmt) == SQLITE_ROW) {
                    
                    
                    //循环从数据库数据，添加到数组
                    let cName = UnsafePointer(sqlite3_column_text(stmt, 5))
                    let cdetail = UnsafePointer(sqlite3_column_text(stmt, 4))
                    let ccate = UnsafePointer(sqlite3_column_text(stmt, 3))
                    //let cdetail = sqlite3_column_int(stmt, 1)
                    
                    let name = String.init(cString: cName!)
                    let detail = String.init(cString: cdetail!)
                    let cate = String.init(cString: ccate!)
                    //let detail = Int(cAge)
                    
                    print("\(name) \(detail) \(cate)")
                    m.insert(name: name, detail: detail, category: cate)
                }
            }
        }
        
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //MARK -- tabbar delegate
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag != 1{
            //发送给所有动作页面停止滚动消息 优化内存
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StopRollingMotionsControllerNotification"), object: nil, userInfo: nil)
        }else {
            //发送给所有动作页面开始滚动消息
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StartRollingMotionsControllerNotification"), object: nil, userInfo: nil)
        }
        
        //主页
        if item.tag != 0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StopRollingMainPageNotification"), object: nil, userInfo: nil)
        }else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StartRollingMainPageNotification"), object: nil, userInfo: nil)
        }
        
        
    }
    
    
    
    
}
