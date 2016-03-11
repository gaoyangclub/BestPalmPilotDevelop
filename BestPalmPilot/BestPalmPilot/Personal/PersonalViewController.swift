//
//  PersonalViewController.swift
//  BestPalmPilot
//
//  Created by admin on 16/3/2.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit
/** 个人中心 */
class PersonalViewController: UIViewController {

    private lazy var topArea:UIView = {
       let view = UIView()
        self.view.addSubview(view)
        view.backgroundColor = BestUtils.deputyColor
        view.snp_makeConstraints(closure: { [weak self](make) -> Void in
            make.left.right.top.equalTo(self!.view)
            make.height.equalTo(130)
        })
        return view;
    }()
    
    private lazy var logoArea:UIView = {
        let view = UIView()
        self.topArea.addSubview(view)
        view.backgroundColor = UIColor.whiteColor()
        let radius:CGFloat = 36
        view.layer.cornerRadius = radius
        view.snp_makeConstraints(closure: { [weak self](make) -> Void in
            make.centerX.equalTo(self!.topArea)
            make.centerY.equalTo(self!.topArea).offset(-20)
            make.width.equalTo(radius * 2)
            make.height.equalTo(radius * 2)
        })
        let imageView = UIImageView()
        view.addSubview(imageView)
        BatchLoaderForSwift.loadFile("logo", callBack: { (image) -> Void in
            imageView.image = image
        })
        imageView.snp_makeConstraints(closure: { [weak self](make) -> Void in
            make.center.equalTo(view)
        })
        return view;
    }()
    
    private lazy var accountLabel:UILabel = {
        let label = UICreaterUtils.createLabel(16, UIColor.whiteColor(), "名字", true, self.topArea)
        label.snp_makeConstraints(closure: {[weak self] (make) -> Void in
            make.top.equalTo(self!.logoArea.snp_bottom).offset(16)
            make.centerX.equalTo(self!.topArea)
        })
        return label
    }()
    
    private lazy var logoutButton:UIButton = {
        let btn = UIButton(type: UIButtonType.System)
//        btn.layer.cornerRadius = 5
        let normalColor:UIColor = UIColor.whiteColor()
        btn.backgroundColor = normalColor
        let title:NSString = "退出登录"
        btn.setTitle(title as String, forState: UIControlState.Normal)
        btn.setTitleColor(UICreaterUtils.colorBlack, forState: UIControlState.Normal)
        self.view.addSubview(btn)
        
        btn.titleLabel?.font = UIFont.systemFontOfSize(16)//weight文字线条粗细 ,weight:2
        btn.snp_makeConstraints(closure: {[weak self] (make) -> Void in
            make.left.right.equalTo(self!.view)
            make.height.equalTo(56)
            make.top.equalTo(self!.topArea.snp_bottom)
        })
        return btn
    }()
    
    private lazy var versionLabel:UILabel = {
        let label = UICreaterUtils.createLabel(16, UICreaterUtils.colorBlack, "版本", true, self.view)
        label.snp_makeConstraints(closure: {[weak self] (make) -> Void in
            make.bottom.equalTo(self!.view).offset(-30)
            make.centerX.equalTo(self!.view)
        })
        return label
    }()
    
    private lazy var titleView:UIView = UIView()
    private lazy var titleLabel:UILabel = BestUtils.createNavigationTitleLabel(self.titleView)
    
    private func initTitleArea(){
        self.view.backgroundColor = BestUtils.backgroundColor//UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1)
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        self.tabBarController?.navigationItem.titleView = titleView
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.text = "个人中心"
        
        accountLabel.text = UserDefaultCache.getUsername()! + "，您好！"
        accountLabel.sizeToFit()
        
        versionLabel.text = "版本信息:" + BestRemoteFacade.appVersion
        
        logoutButton.addTarget(self, action: "logoutClick:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func logoutClick(sender:UIButton){
        BestUtils.showAlert(message: "确定退出当前账号吗？", parentController: self) { [weak self] _ -> Void in
            UserDefaultCache.clearUser()//先清除缓存
            self!.drawerController.closeDrawerAnimated(true, completion: nil)
            self!.rootNavigationController.popToRootViewControllerAnimated(false)//直接跳到根页面
            self!.rootNavigationController.viewControllers[0].viewDidLoad() //重新刷新页面
        }
    }
    
//    private func getTitleString()->String{
//        if UserDefaultCache.getUsername() != nil {
//            if UserDefaultCache.getUsercode() != nil {
//                return UserDefaultCache.getUsername()! + "\n" + UserDefaultCache.getUsercode()!
//            }
//            return UserDefaultCache.getUsername()!
//        }
//        return UserDefaultCache.getUsercode() ?? "用户名/工号"
//    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        RootNavigationControl.getInstance().navigationColor = BestUtils.deputyColor
        initTitleArea()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        RootNavigationControl.getInstance().navigationColor = UIColor.whiteColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
