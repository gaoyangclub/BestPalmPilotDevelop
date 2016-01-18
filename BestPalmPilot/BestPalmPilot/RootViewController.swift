//
//  ViewController.swift
//  FinanceApplicationTest
//
//  Created by 高扬 on 15/10/17.
//  Copyright (c) 2015年 高扬. All rights reserved.
//

import UIKit

class RootViewController: TabViewController,LoginViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "主页"
//        UserDefaultCache.clearUser()
        if !UserDefaultCache.hasUser(){//用户不存在
            let delayInSeconds:Int64 =  100000000  * 2
            
            let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                //                self.rootNavigationController.pushViewController(LoginViewController(), animated: true)
                let loginController = LoginViewController()
                loginController.delegate = self
                self.presentViewController(loginController, animated: true, completion: { () -> Void in
//                    print("登陆界面弹出完毕")
                })
            })
        }else{
            initData()//初始化界面
        }
        // Do any additional setup after loading the view, typically from a nib.
//        CoreDataCache.deleteAllData(LoginUserCoreData.self)
//        CoreDataCache.updateDataByIndex(LoginUserCoreData.self) { (obj) -> Void in
//            obj.setValue("agagaga", forKey: "username")
//        }
//        let data:AnyObject? = CoreDataCache.getDataByIndex(LoginUserCoreData.self)
//        if data == nil{
//            print("先登陆")
//        }else{
//            initData()//初始化界面
//        }
    }

    func loginViewWillDismiss(controller: LoginViewController) {
        initData()//继续初始化界面
    }
    
    private func initData(){
        dataProvider = [
            TabData(data: TabRendererVo(title:"等待审批",iconUrl:"icon_02"),controller: ApprovePageHomeController()),
            TabData(data: TabRendererVo(title:"最新动态",iconUrl:"icon_06"),controller: AViewController()),
            TabData(data: TabRendererVo(title:"版本信息",iconUrl:"icon_04"),controller: AViewController())
//            TabData(data: TabRendererVo(title:"盘古",iconUrl:"icon_05"),controller: AViewController())
        ]
        itemClass = MyTabItemRenderer.self
//        tabBarHeight = 40
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

