//
//  AccountSideHomeController.swift
//  BestPalmPilot
//
//  Created by admin on 16/1/25.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit

//账号设置侧边栏
public class AccountSideHomeController: UIViewController {

    public static let DrawerWidth:CGFloat = 200
    
    private lazy var container:UIView = {
       let view = UIView()
        self.view.addSubview(view)
        view.snp_makeConstraints(closure: {[weak self] (make) -> Void in
            make.right.top.bottom.equalTo(self!.view)
            make.width.equalTo(AccountSideHomeController.DrawerWidth)
        })
        return view
    }()
    
    private lazy var titleArea:UIView = {
        let view = UIView()
        self.container.addSubview(view)
        view.backgroundColor = BestUtils.backgroundColor
        view.snp_makeConstraints(closure: {[weak self] (make) -> Void in
            make.left.right.top.equalTo(self!.container)
            make.height.equalTo(100)
        })
        
        let line = UIView()
        view.addSubview(line)
        line.backgroundColor = UICreaterUtils.normalLineColor
        line.snp_makeConstraints(closure: { (make) -> Void in //[weak self]
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(UICreaterUtils.normalLineWidth)
        })
        return view
    }()
    
    private lazy var bottomArea:UIView = {
        let view = UIView()
        self.container.addSubview(view)
//        view.backgroundColor = BestUtils.backgroundColor
        view.snp_makeConstraints(closure: {[weak self] (make) -> Void in
            make.top.equalTo(self!.titleArea.snp_bottom)
            make.left.right.bottom.equalTo(self!.container)
        })
        return view
    }()
    
    private lazy var userIcon:UIFlatImageTabItem = {
        let tabItem = UIFlatImageTabItem()
        self.titleArea.addSubview(tabItem)
        tabItem.userInteractionEnabled = false
        tabItem.sizeType = .FillWidth
        tabItem.normalColor = UICreaterUtils.colorFlat
        
        BatchLoaderForSwift.loadFile("userIcon", callBack: { (image) -> Void in
            tabItem.image = image
        })
        
        tabItem.snp_makeConstraints { [weak self](make) -> Void in
            make.top.equalTo(self!.titleArea).offset(35)
            make.height.equalTo(30)
            make.width.equalTo(46)
            make.left.equalTo(self!.titleArea)
        }
        return tabItem
    }()
    
    private lazy var titleLabel:UILabel = {
       let label = UICreaterUtils.createLabel(26, UICreaterUtils.colorFlat, "名字", true, self.titleArea)
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.Left
        label.snp_makeConstraints(closure: {[weak self] (make) -> Void in
            make.top.equalTo(self!.userIcon)
            make.left.equalTo(self!.userIcon.snp_right)
            make.right.equalTo(self!.titleArea).offset(-25)
        })
        return label
    }()
    
    lazy var setupButton:UIButton = {
        let btn = UIButton(type: UIButtonType.System)
        btn.layer.cornerRadius = 5
        let normalColor:UIColor = FlatUIColors.belizeHoleColor()
        btn.backgroundColor = normalColor
        let title:NSString = "系统设置"
        btn.setTitle(title as String, forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.bottomArea.addSubview(btn)
        
        btn.titleLabel?.font = UIFont.systemFontOfSize(20)//weight文字线条粗细 ,weight:2
        
        btn.snp_makeConstraints(closure: {[weak self] (make) -> Void in
            make.left.equalTo(self!.bottomArea).offset(10)
            make.right.equalTo(self!.bottomArea).offset(-10)
            make.top.equalTo(self!.bottomArea).offset(20)
            make.height.equalTo(45)
        })
        return btn
    }()
    
    lazy var logoutButton:UIButton = {
        let btn = UIButton(type: UIButtonType.System)
        btn.layer.cornerRadius = 5
        let normalColor:UIColor = FlatUIColors.belizeHoleColor()
        btn.backgroundColor = normalColor
        let title:NSString = "退出登录"
        btn.setTitle(title as String, forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.bottomArea.addSubview(btn)
        
        btn.titleLabel?.font = UIFont.systemFontOfSize(20)//weight文字线条粗细 ,weight:2
        btn.snp_makeConstraints(closure: {[weak self] (make) -> Void in
            make.left.right.height.equalTo(self!.setupButton)
            make.top.equalTo(self!.setupButton.snp_bottom).offset(10)
        })
        return btn
    }()
    
    private func initController(){
        self.view.backgroundColor = UIColor.grayColor()
        setupButton.enableElement = false
        setupButton.addTarget(self, action: "setupClick:", forControlEvents: UIControlEvents.TouchUpInside)
        logoutButton.addTarget(self, action: "logoutClick:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func setupClick(sender:UIButton){
        
    }
    
    func logoutClick(sender:UIButton){
        BestUtils.showAlert(message: "确定退出当前账号吗？", parentController: self) { [weak self] _ -> Void in
            UserDefaultCache.clearUser()//先清除缓存
            self!.drawerController.closeDrawerAnimated(true, completion: nil)
            self!.rootNavigationController.popToRootViewControllerAnimated(false)//直接跳到根页面
            self!.rootNavigationController.viewControllers[0].viewDidLoad() //重新刷新页面
        }
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        titleLabel.text = getTitleString()
    }
    
    private func getTitleString()->String{
        if UserDefaultCache.getUsername() != nil {
            if UserDefaultCache.getUsercode() != nil {
                return UserDefaultCache.getUsername()! + "\n" + UserDefaultCache.getUsercode()!
            }
            return UserDefaultCache.getUsername()!
        }
        return UserDefaultCache.getUsercode() ?? "用户名/工号"
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        initController()
    }

    public override func didReceiveMemoryWarning() {
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
