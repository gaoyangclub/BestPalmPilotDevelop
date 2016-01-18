//
//  LoginViewController.swift
//  BestPalmPilot
//
//  Created by admin on 16/1/13.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit

@objc public protocol LoginViewDelegate {
    // MARK: - Delegate functions
    optional func loginViewWillDismiss(controller:LoginViewController)
    optional func loginViewDidDismiss(controller:LoginViewController)
}
public class LoginViewController: UIViewController,UITextFieldDelegate {
    
    weak var delegate:LoginViewDelegate?
    
    private lazy var logoImage:UIImageView = {
       let imageView = UIImageView()
        self.view.addSubview(imageView)
//        imageView.layer.cornerRadius = 50
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        BatchLoaderUtil.loadFile("bestLogo.jpeg", callBack: { (image, params) -> Void in
            imageView.image = image
            })
        return imageView
    }()
    
    private lazy var usernameBack:UIView = {
        let view = UIView()
        view.layer.borderColor = UICreaterUtils.colorFlat.CGColor
        view.layer.borderWidth = 1//UICreaterUtils.normalLineWidth
        view.layer.cornerRadius = 2
        view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var userText:UITextField = {
       let text = UITextField()
        text.clearButtonMode = UITextFieldViewMode.WhileEditing
        text.textColor = UICreaterUtils.colorBlack
        self.usernameBack.addSubview(text)
        text.delegate = self
        text.placeholder = "请输入用户名"
        text.returnKeyType = UIReturnKeyType.Done
        return text
    }()
    
    private lazy var userIcon:UIFlatImageTabItem = {
        let tabItem = UIFlatImageTabItem()
        self.usernameBack.addSubview(tabItem)
        tabItem.userInteractionEnabled = false
        tabItem.sizeType = .FillWidth
        tabItem.normalColor = UIColor.grayColor()
//        tabItem.selectColor = UICreaterUtils.colorRise
        
        BatchLoaderUtil.loadFile("userIcon", callBack: { (image, params) -> Void in
            tabItem.image = image
        })
        return tabItem
    }()
    
    private lazy var passwordBack:UIView = {
        let view = UIView()
        view.layer.borderColor = UICreaterUtils.colorFlat.CGColor
        view.layer.borderWidth = 1//UICreaterUtils.normalLineWidth
        view.layer.cornerRadius = 2
        view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var passwordText:UITextField = {
        let text = UITextField()
        text.clearButtonMode = UITextFieldViewMode.WhileEditing //输入的时候显示close按钮
        text.textColor = UICreaterUtils.colorBlack
        self.passwordBack.addSubview(text)
        text.delegate = self //文本交互代理
        text.placeholder = "请输入密码"
        text.returnKeyType = UIReturnKeyType.Done //键盘return键样式
        text.secureTextEntry = true //密码显示
        return text
    }()
    
    private lazy var passwordIcon:UIFlatImageTabItem = {
        let tabItem = UIFlatImageTabItem()
        self.passwordBack.addSubview(tabItem)
        tabItem.userInteractionEnabled = false
        tabItem.sizeType = .FillWidth
        tabItem.normalColor = UIColor.grayColor()
        //        tabItem.selectColor = UICreaterUtils.colorRise
        
        BatchLoaderUtil.loadFile("passwordIcon", callBack: { (image, params) -> Void in
            tabItem.image = image
        })
        return tabItem
    }()
    
    lazy var submitButton:UIButton = {
        let btn = UIButton(type: UIButtonType.System)
        btn.layer.cornerRadius = 2
        let normalColor:UIColor = BestUtils.themeColor
        btn.backgroundColor = normalColor
        let title:NSString = "登  陆"
        btn.setTitle(title as String, forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.view.addSubview(btn)
        
//        var attstr:NSMutableAttributedString = NSMutableAttributedString(string: title as String)
//        attstr.addAttribute(NSUnderlineStyleAttributeName, value: 1, range: NSMakeRange(0, title.length))
//        btn.titleLabel?.attributedText = attstr
        btn.titleLabel?.font = UIFont.systemFontOfSize(18)//weight文字线条粗细 ,weight:2
        btn.addTarget(self, action: "submitClick:", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    //登陆信息
    func submitClick(sender:UIButton){
        if userText.text == nil || userText.text!.isEmpty {
            JLToast.makeText("请输入用户名!").show()
            return
        }else if passwordText.text == nil || passwordText.text!.isEmpty{
            JLToast.makeText("请输入密码!").show()
            return
        }
        BestRemoteFacade.login(userText.text!, password: passwordText.text!, appid: "1", mobileInfo: "1") {[unowned self] (json,var isSuccess,_) -> Void in
            var failMsg:String?
            if isSuccess{
                if json != nil && json!["issuccess"].boolValue {
                    print("登陆成功token:\(json!["token"].stringValue)")
                    
                    if !json!["usercode"].stringValue.isEmpty{
                        UserDefaultCache.setUsercode(json!["usercode"].stringValue)
                    }else{
                        UserDefaultCache.setUsercode(self.userText.text!) //只能记录输入的文字
                    }
                    if !json!["username"].stringValue.isEmpty{
                        UserDefaultCache.setUsername(json!["username"].stringValue)
                    }
                    UserDefaultCache.setPassword(self.passwordText.text!)
                    UserDefaultCache.setToken(json!["token"].stringValue)
                    self.delegate?.loginViewWillDismiss?(self)
                    
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        //                print("登陆界面关闭")
                        self.delegate?.loginViewDidDismiss?(self)
                    })
                }else{
                    failMsg = json!["failmsg"].stringValue
                    isSuccess = false
                }
            }else{
                failMsg = "网络连接错误,请检查您手机的网络状态或者稍后登陆"
            }
            if(!isSuccess){ //登陆失败
                let alertController = UIAlertController(title: "登陆失败", message: failMsg, preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
//                let delayInSeconds:Int64 =  100000000  * 2
//                let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
//                dispatch_after(popTime, dispatch_get_main_queue(), {
//                _ = UIAlertController(title: "登陆失败", message: json["failmsg"].stringValue, preferredStyle: UIAlertControllerStyle.Alert)
//                    self.presentViewController(alertController, animated: true, completion: nil)
//                })
            }
        }
    }
    
    //键盘按return键返回
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()//取消第一响应
        return true
    }
    
    private func layoutSubViews(){
        
        logoImage.snp_makeConstraints { [unowned self](make) -> Void in
            make.left.right.equalTo(self.usernameBack)
            make.bottom.equalTo(self.usernameBack.snp_top)
            make.top.equalTo(self.view)
        }
        usernameBack.snp_makeConstraints { [unowned self](make) -> Void in
            make.left.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).offset(-30)
            make.top.equalTo(self.view.snp_centerY)
            make.height.equalTo(40)
        }
        userIcon.snp_makeConstraints { [unowned self](make) -> Void in
            make.top.equalTo(self.usernameBack).offset(5)
            make.bottom.equalTo(self.usernameBack).offset(-5)
            make.left.equalTo(self.usernameBack)
            make.width.equalTo(46)
        }
        userText.snp_makeConstraints { [unowned self](make) -> Void in
            make.left.equalTo(self.userIcon.snp_right)
            make.top.bottom.right.equalTo(self.usernameBack)
        }
        passwordBack.snp_makeConstraints { [unowned self](make) -> Void in
            make.left.right.height.equalTo(self.usernameBack)
            make.top.equalTo(self.usernameBack.snp_bottom).offset(20)
        }
        passwordIcon.snp_makeConstraints { [unowned self](make) -> Void in
            make.top.equalTo(self.passwordBack).offset(5)
            make.bottom.equalTo(self.passwordBack).offset(-5)
            make.left.equalTo(self.passwordBack)
            make.width.equalTo(46)
        }
        passwordText.snp_makeConstraints { [unowned self](make) -> Void in
            make.left.equalTo(self.userText)
            make.top.bottom.right.equalTo(self.passwordBack)
        }
        submitButton.snp_makeConstraints { [unowned self](make) -> Void in
            make.left.right.height.equalTo(self.usernameBack)
            make.top.equalTo(self.passwordBack.snp_bottom).offset(20)
        }
    }
    
    override public func viewDidLoad() {
        layoutSubViews()
        
//        userText.becomeFirstResponder()
        
        super.viewDidLoad()
//        self.title = "登陆页面"
        self.view.backgroundColor = UIColor(red: 241/255, green: 243/255, blue: 247/255, alpha: 1)

        // Do any additional setup after loading the view.
    }

    override public func didReceiveMemoryWarning() {
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
