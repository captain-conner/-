//
//  WebExploreController.swift
//  健身软件
//
//  Created by CaptainSeanConner on 2017/3/21.
//  Copyright © 2017年 $CaptainConner$. All rights reserved.
//

import UIKit
import WebKit
class WebExploreController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let webview = WKWebView(frame: self.view.frame)
        self.view.addSubview(webview)
        
   
        //let url = URL(string: "http://u4078698.zuodanye.maka.im/viewer/0OYW75PZ")
        //自己的django网页地址 http://127.0.0.1:8000/workout/
        //图片布局网站 http://demo.cssmoban.com/cssthemes3/ft5_59_photo/index.html
        //let url = URL(string: "http://demo.cssmoban.com/cssthemes3/ft5_59_photo/index.html")
        let url = URL(string: "http://127.0.0.1:8000/app/")
        let re = URLRequest(url: url!)
        
        webview.load(re)
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

}
