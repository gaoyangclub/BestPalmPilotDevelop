//
//  AViewController.swift
//  Lesson 14 UITabBarController
//
//  Created by 高扬 on 15/9/15.
//  Copyright (c) 2015年 高扬. All rights reserved.
//

import UIKit
import CoreLibrary

class AViewController: UIViewController {

    override func viewDidAppear(animated: Bool) {
//        println("界面A完全显示")
    }
    
    override func viewWillAppear(animated: Bool) {
//        print("界面A将要显示")
        super.viewWillAppear(animated)
        initTitleArea()
    }
    
    private lazy var titleView:UIView = {
        let back = UIView()
        let label:UILabel = UICreaterUtils.createLabel(20, UIColor.whiteColor(), self.title!, true, back)
        label.font = UIFont.systemFontOfSize(20)//20号 ,weight:2
        
        back.addSubview(label)
        label.snp_makeConstraints { (make) -> Void in //[weak self]
            make.center.equalTo(back)
        }
        return back
    }()
    
    private func initTitleArea(){
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
//        self.tabBarController?.navigationItem.titleView = nil
        self.tabBarController?.navigationItem.titleView = titleView
    }
    
    private lazy var tipsLabel:UILabel = {
       let label = UICreaterUtils.createLabel(50, UICreaterUtils.colorFlat,"敬请期待",true,self.view)
        label.snp_makeConstraints { [weak self](make) -> Void in //[weak self]
            make.center.equalTo(self!.view)
        }
        return label
    }()
    
    override func viewDidLoad() {
//        title = "界面A"
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        self.navigationController?.setToolbarHidden(true, animated: true)
        
        super.viewDidLoad()
        
        self.view.backgroundColor = BestUtils.backgroundColor
        tipsLabel.hidden = false

//        let color:CGFloat = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
//        let color1:CGFloat = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
//        let color2:CGFloat = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
////        var color3:CGFloat = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
//        
//        view.backgroundColor = UIColor(red: color, green: color1, blue: color2, alpha: 1)//UIColor.blueColor().lighterColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
