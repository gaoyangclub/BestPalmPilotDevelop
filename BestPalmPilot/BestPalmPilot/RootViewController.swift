//
//  ViewController.swift
//  FinanceApplicationTest
//
//  Created by 高扬 on 15/10/17.
//  Copyright (c) 2015年 高扬. All rights reserved.
//

import UIKit

class RootViewController: TabViewController,LoginViewDelegate,EAIntroDelegate {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
//        self.showViewController(<#T##vc: UIViewController##UIViewController#>, sender: <#T##AnyObject?#>)
    }
    
    private func checkLoginView(){
        self.rootNavigationController.navigationBar.hidden = false
        
        if !UserDefaultCache.hasUser(){//用户不存在
            let delayInSeconds:Int64 =  100000000  * 2
            
            let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                //                self.rootNavigationController.pushViewController(LoginViewController(), animated: true)
                let loginController = LoginViewController()
                loginController.delegate = self
                self.presentViewController(loginController, animated: true, completion: { () -> Void in
                    //                    print("登录界面弹出完毕")
                })
            })
        }else{
            initData()//初始化界面
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.title = "登  录"
        self.view.backgroundColor = BestUtils.backgroundColor
        
        if UserDefaultCache.getHasIntro() != nil && UserDefaultCache.getHasIntro()!{
            checkLoginView()
        }else{//打开介绍
            showIntroWithCrossDissolve()
        }
//        UserDefaultCache.clearUser()
        // Do any additional setup after loading the view, typically from a nib.
//        CoreDataCache.deleteAllData(LoginUserCoreData.self)
//        CoreDataCache.updateDataByIndex(LoginUserCoreData.self) { (obj) -> Void in
//            obj.setValue("agagaga", forKey: "username")
//        }
//        let data:AnyObject? = CoreDataCache.getDataByIndex(LoginUserCoreData.self)
//        if data == nil{
//            print("先登录")
//        }else{
//            initData()//初始化界面
//        }
    }
    
    private func showIntroWithCrossDissolve(){
        self.rootNavigationController.navigationBar.hidden = true
//      self.rootNavigationController?.navigationBarHidden = true
        
        let bounds = self.view.bounds
        let offsetY:CGFloat = -120
        
        let page3 = EAIntroPage()
        page3.titlePositionY = bounds.height / 2 + offsetY
        page3.titleColor = UICreaterUtils.colorBlack
        page3.descColor = page3.titleColor
        page3.titleFont = UIFont.systemFontOfSize(26)
        page3.title = "准  奏"
        page3.descPositionY = page3.titlePositionY - 20
        page3.descFont = UIFont.systemFontOfSize(16)
        page3.desc = "想怎么批就怎么P"
//        page3.bgImage = UIImage(named: "page3")
        page3.titleIconView = UIImageView(image: UIImage(named: "page3"))
        page3.titleIconPositionY = page3.descPositionY - 50
        page3.bgColor = UIColor(red: 248/255, green: 223/255, blue: 188/255, alpha: 1)//FlatUIColors.dodgerBlueColor()
        
        let page1 = EAIntroPage()
        page1.titlePositionY = bounds.height / 2 + offsetY
        page1.titleColor = UICreaterUtils.colorBlack
        page1.descColor = page1.titleColor
        page1.titleFont = UIFont.systemFontOfSize(26)
        page1.title = "系  统"
        page1.descPositionY = page1.titlePositionY - 20
        page1.descFont = UIFont.systemFontOfSize(16)
        page1.desc = "一键审批"//F1,AMS,OA
//        page1.bgImage = UIImage(named: "page2")
        page1.titleIconView = UIImageView(image: UIImage(named: "page1"))
        page1.titleIconPositionY = page1.descPositionY - 50
        page1.bgColor = UIColor(red: 249/255, green: 245/255, blue: 227/255, alpha: 1)//FlatUIColors.jaffaColor()
        
        let page2 = EAIntroPage()
        page2.titleColor = UICreaterUtils.colorBlack
        page2.descColor = page2.titleColor
        page2.titlePositionY = bounds.height / 2 + offsetY
        page2.titleFont = UIFont.systemFontOfSize(26)
        page2.title = "搜  索"
        page2.descPositionY = page2.titlePositionY - 20
        page2.descFont = UIFont.systemFontOfSize(16)
        page2.desc = "查找审批单快捷方便"
//        page2.bgImage = UIImage(named: "page1")
        page2.titleIconView = UIImageView(image: UIImage(named: "page2"))
        page2.titleIconPositionY = page2.descPositionY// - 10
        page2.bgColor = UIColor(red: 231/255, green: 242/255, blue: 255/255, alpha: 1)//FlatUIColors.lightSeaGreenColor()
        
//        let page4 = EAIntroPage()
//        page4.titlePositionY = bounds.height / 2 + offsetY
//        page4.titleFont = UIFont.systemFontOfSize(50)
//        page4.title = "时时通话";
//        page4.descPositionY = page4.titlePositionY - 20
//        page4.descFont = UIFont.systemFontOfSize(26)
//        page4.desc = "下达指令直接拔打号码";
////        page4.bgImage = UIImage(named: "bg4")
////        page4.titleIconView = UIImageView(image: UIImage(named: "title4"))
//        page4.bgColor = FlatUIColors.lightWisteriaColor()
        
        let intro = EAIntroView(frame: bounds, andPages: [page3,page1,page2])
        intro.delegate = self
        
        intro.skipButton = skipButton
        intro.pageControl = pageControl
        
        intro.showInView(self.view, animateDuration: 0.3)
//        intro.snp_makeConstraints { (make) -> Void in
//            make.left.right.top.bottom.equalTo(self.view)
//        }
    }
    
    private lazy var pageControl:DWPageControl = {
        let controller = DWPageControl()
        controller.activeColor = UIColor(red: 193/255, green: 156/255, blue: 105/255, alpha: 1)
        controller.inactiveColor = UIColor.whiteColor()
        controller.cornerRadius = 5
        return controller
    }()
    
    private lazy var skipButton:UIButton = {
        let btn = UIButton(type: UIButtonType.System)
        //            btn.frame = CGRectMake(0,0,60,60)
        btn.layer.cornerRadius = 10
        btn.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        let title:NSString = "跳过"
        btn.titleLabel?.font = UIFont.systemFontOfSize(14)//weight文字线条粗细 ,weight:2
        btn.setTitle(title as String, forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        var attstr:NSMutableAttributedString = NSMutableAttributedString(string: title as String)
        attstr.addAttribute(NSUnderlineStyleAttributeName, value: 0, range: NSMakeRange(0, title.length))
        btn.titleLabel?.attributedText = attstr
        //            btn.addTarget(self, action: "submitClick:", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    
    func introDidFinish(introView: EAIntroView!) {
//        print("介绍完成")
        UserDefaultCache.setHasIntro(true)//系统介绍过了 永远不会再打开
        checkLoginView()
    }

    func loginViewWillDismiss(controller: LoginViewController) {
        initData()//继续初始化界面
    }
    
    private var selfDataProvider:[TabData]?
    private func initData(){
        if selfDataProvider == nil{
            selfDataProvider = [
                TabData(data: TabRendererVo(title:"等待审批",iconUrl:"home"),controller: ApprovePageHomeController()),
//                TabData(data: TabRendererVo(title:"最新动态",iconUrl:"latest_news"),controller: createAViewController("掌握最新动态")),
                TabData(data: TabRendererVo(title:"个人中心",iconUrl:"personal"),controller:PersonalViewController()
//                    createAViewController("当前版本信息")
                )
                //            TabData(data: TabRendererVo(title:"盘古",iconUrl:"icon_05"),controller: AViewController())
            ]
            dataProvider = selfDataProvider
            itemClass = MyTabItemRenderer.self
            //        tabBarHeight = 40
        }else{
            let controller = getCurrentController()
            if controller is BaseTableViewController{
                (controller as! BaseTableViewController).refreshHeader()
            }
        }
    }
    
    private func createAViewController(title:String)->AViewController{
        let a = AViewController()
        a.title = title
        return a
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

