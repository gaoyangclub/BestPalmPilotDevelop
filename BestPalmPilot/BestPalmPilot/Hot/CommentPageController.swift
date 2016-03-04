//
//  CommentPageController.swift
//  BestPalmPilot
//
//  Created by admin on 16/2/1.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit

class CommentPageController: UIViewController,UITextFieldDelegate  {

    private lazy var titleView:UIView = UIView()
    private lazy var titleLabel:UILabel = BestUtils.createNavigationTitleLabel(self.titleView)
    private lazy var leftItem:UIBarButtonItem = BestUtils.createNavigationLeftButtonItem(self,action: "cancelClick")
    private func initTitleArea(){
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = leftItem
        self.navigationItem.titleView = titleView
        self.title = "系统点评"
        titleLabel.text = self.title
        
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTitleArea()
        initSubview()
        // Do any additional setup after loading the view.
    }
    
    private lazy var subTitleBack:UIView = {
        let view = UIView()
        view.backgroundColor = BestUtils.backgroundColor
        self.view.addSubview(view)
        view.snp_makeConstraints(closure: { [weak self](make) -> Void in
            make.left.right.top.equalTo(self!.view)
            make.height.equalTo(60)
        })
        return view
    }()
    
    private lazy var subTitleLabel:UILabel = {
       let label = UICreaterUtils.createLabel(18, UICreaterUtils.colorBlack, "", true, self.subTitleBack)
        label.snp_makeConstraints(closure: { [weak self](make) -> Void in
            make.centerY.equalTo(self!.subTitleBack)
            make.left.equalTo(self!.subTitleBack).offset(15)
        })
        return label
    }()
    
    private lazy var bottomArea:UIView = {
        let view = UIView()
        self.view.addSubview(view)
        
        view.backgroundColor = BestUtils.backgroundColor
        view.snp_makeConstraints(closure: {[weak self] (make) -> Void in
            make.left.right.bottom.equalTo(self!.view)
            make.height.equalTo(60)
        })
        
        let topLine = UIView()
        view.addSubview(topLine)
        topLine.backgroundColor = UICreaterUtils.normalLineColor
        topLine.snp_makeConstraints(closure: {[weak self] (make) -> Void in
            make.left.right.top.equalTo(view)
            make.height.equalTo(UICreaterUtils.normalLineWidth)
        })
        return view
    }()
    
    private lazy var submitButton:UIButton = {
        let btn = UIButton(type: UIButtonType.System)
        btn.layer.cornerRadius = 5
        let normalColor:UIColor = BestUtils.deputyColor
        btn.backgroundColor = normalColor
        let title:NSString = "提  交"
        btn.setTitle(title as String, forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.bottomArea.addSubview(btn)
        
        btn.snp_makeConstraints { [weak self](make) -> Void in
            make.left.equalTo(self!.bottomArea).offset(10)
            make.right.equalTo(self!.bottomArea).offset(-10)
            make.centerY.equalTo(self!.bottomArea)
            make.height.equalTo(45)
        }
        btn.titleLabel?.font = UIFont.systemFontOfSize(22)//weight文字线条粗细 ,weight:2
        return btn
    }()
    
    private lazy var shareArea:UIView = {
        let view = UIView()
        self.view.addSubview(view)
        view.snp_makeConstraints(closure: {[weak self] (make) -> Void in
            make.bottom.equalTo(self!.bottomArea.snp_top)
            make.left.right.equalTo(self!.view)
            make.height.equalTo(60)
        })
        return view
    }()
    
    private lazy var shareLabel:UILabel = {
        let label = UICreaterUtils.createLabel(16, UICreaterUtils.colorBlack, "", true, self.subTitleBack)
        label.snp_makeConstraints(closure: { [weak self](make) -> Void in
            make.centerY.equalTo(self!.shareArea)
            make.left.equalTo(self!.shareArea).offset(15)
        })
        return label
    }()
    
    private lazy var starArea:UIView = {
        let view = UIView()
        self.view.addSubview(view)
        view.snp_makeConstraints(closure: {[weak self] (make) -> Void in
            make.top.equalTo(self!.subTitleBack.snp_bottom)
            make.left.right.equalTo(self!.view)
            make.height.equalTo(60)
        })
        return view
    }()
    private lazy var starLabel:UILabel = {
        let label = UICreaterUtils.createLabel(16, UICreaterUtils.colorBlack, "", true, self.starArea)
        label.snp_makeConstraints(closure: { [weak self](make) -> Void in
            make.centerY.equalTo(self!.starArea)
            make.left.equalTo(self!.starArea).offset(15)
        })
        return label
    }()
    
    private lazy var starList:[UIFlatImageTabItem] = {
        var list:[UIFlatImageTabItem] = []
        let count = 5
        var preView:UIView?
        for i in 0..<count{
            let tabItem = UIFlatImageTabItem()
            BatchLoaderForSwift.loadFile("star", callBack: { (image) -> Void in
                tabItem.image = image
            })
            self.starArea.addSubview(tabItem)
            tabItem.sizeType = .FillWidth
            tabItem.normalColor = UICreaterUtils.colorFlat
            tabItem.selectColor = UIColor.orangeColor()
            
            tabItem.tag = i
            tabItem.snp_makeConstraints(closure: { [weak self](make) -> Void in
                make.width.equalTo(40)
                make.height.equalTo(26)
                make.centerY.equalTo(self!.starArea)
                if preView == nil{
                    make.left.equalTo(self!.starLabel.snp_right).offset(8)
                }else{
                    make.left.equalTo(preView!.snp_right)
                }
            })
            tabItem.addTarget(self, action: "starSelectHandler:", forControlEvents: UIControlEvents.TouchUpInside)
            preView = tabItem
            list.append(tabItem)
        }
        return list
    }()
    
    private lazy var phoneArea:UIView = {
        let view = UIView()
        self.view.addSubview(view)
        view.snp_makeConstraints(closure: {[weak self] (make) -> Void in
            make.bottom.equalTo(self!.shareArea.snp_top)
            make.left.right.equalTo(self!.view)
            make.height.equalTo(80)
        })
        return view
    }()
    private lazy var phoneLabel:UILabel = {
        let label = UICreaterUtils.createLabel(16, UICreaterUtils.colorBlack, "", true, self.phoneArea)
        label.snp_makeConstraints(closure: { [weak self](make) -> Void in
            make.top.equalTo(self!.phoneArea).offset(5)
            make.left.equalTo(self!.phoneArea).offset(15)
        })
        return label
    }()
    private lazy var phoneText:UITextField = {
        let view = UIView()
        view.layer.borderColor = UICreaterUtils.colorFlat.CGColor
        view.layer.borderWidth = 1//UICreaterUtils.normalLineWidth
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor.whiteColor()
        self.phoneArea.addSubview(view)
        
        view.snp_makeConstraints { [weak self](make) -> Void in
//            make.bottom.equalTo(self!.phoneArea)//.offset(-5)
            make.top.equalTo(self!.phoneLabel.snp_bottom).offset(10)
            make.height.equalTo(40)
            make.right.equalTo(self!.phoneArea).offset(-15)
            make.left.equalTo(self!.phoneLabel)
        }
        
        let text = UITextField()
        text.clearButtonMode = UITextFieldViewMode.WhileEditing
        text.textColor = UICreaterUtils.colorBlack
        view.addSubview(text)
        text.returnKeyType = UIReturnKeyType.Done
        text.keyboardType = UIKeyboardType.PhonePad//联系方式专用
        
        text.delegate = self
        
        text.snp_makeConstraints(closure: { (make) -> Void in
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view).offset(-5)
            make.top.bottom.equalTo(view)
        })
        return text
    }()
    
    //键盘按return键返回
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()//取消第一响应
        return true
    }
    
    private lazy var detailArea:UIView = {
        let view = UIView()
        self.view.addSubview(view)
        view.snp_makeConstraints(closure: {[weak self] (make) -> Void in
            make.top.equalTo(self!.starArea.snp_bottom)
            make.left.right.equalTo(self!.view)
            make.bottom.equalTo(self!.phoneArea.snp_top)
        })
        return view
    }()
    
    private lazy var detailLabel:UILabel = {
        let label = UICreaterUtils.createLabel(16, UICreaterUtils.colorBlack, "", true, self.detailArea)
        label.snp_makeConstraints(closure: { [weak self](make) -> Void in
            make.top.equalTo(self!.detailArea).offset(10)
            make.left.equalTo(self!.detailArea).offset(15)
        })
        return label
    }()
    private lazy var detailTextView:UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFontOfSize(16)
        textView.scrollEnabled = true
        textView.editable = true
        textView.layer.borderColor = UICreaterUtils.colorFlat.CGColor
        textView.layer.borderWidth = 1//UICreaterUtils.normalLineWidth
        textView.layer.cornerRadius = 5
        self.detailArea.addSubview(textView)
        textView.snp_makeConstraints(closure: { [weak self](make) -> Void in
            make.left.equalTo(self!.detailArea).offset(15)
            make.right.equalTo(self!.detailArea).offset(-15)
            make.bottom.equalTo(self!.detailArea).offset(-10)
            make.top.equalTo(self!.detailLabel.snp_bottom).offset(10)
        })
        return textView
    }()
    
    func starSelectHandler(tabItem:UIFlatImageTabItem){
        fillStar(tabItem.tag + 1)
    }
    
    private func initSubview(){
        subTitleLabel.text = BestRemoteFacade.appName
        subTitleLabel.sizeToFit()
        
        submitButton.addTarget(self, action: "submitClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        shareLabel.text = "同步分享"
        shareLabel.sizeToFit()
        
        starLabel.text = "评分"
        starLabel.sizeToFit()
        
        fillStar(3)
        
        phoneLabel.text = "请留下联系方式:"
        phoneLabel.sizeToFit()
        
        phoneText.placeholder = "联系电话"
        
        detailLabel.text = "请留下意见或建议(100字以内):"
        detailLabel.sizeToFit()
        
        detailTextView.hidden = false
    }
    
    private func fillStar(score:Int){
        for star in starList{
            if star.tag < score {
                star.select = true
            }else{
                star.select = false
            }
        }
    }
    
    func submitClick(sender:UIButton){
        if detailTextView.text == nil || detailTextView.text.isEmpty {
            JLToast.makeText("请输入意见或建议!").show()
            return
        }
        EZLoadingActivity.show("点评提交中", disableUI: true)
        BestRemoteFacade.submitComment(UserDefaultCache.getUsercode()!,score: getLocalScore(),component: "按钮:" + (sender.titleLabel?.text)!, pageTitle: self.title!, detail: generateDetailText()) { [weak self](json, var isSuccess, error) -> Void in
            if self == nil{
                print("CommentPageController对象已经销毁")
                return
            }
            if isSuccess {
                if !json!.boolValue {
                    isSuccess = false
                }
            }
            EZLoadingActivity.hide(success: isSuccess, animated: true)
            if isSuccess {//成功就跳转回主页
                self!.cancelClick()
            }
        }
    }
    
    private func getLocalScore()->Int{
        var score:Int = 0
        for star in starList{
            if star.select {
                score++
            }
        }
        return score
    }
    
    private func generateDetailText()->String{
        var addString = "\n"
        addString += "Star:\(getLocalScore())" + "\n"
        addString += "UserCode:" + UserDefaultCache.getUsercode()! + "\n"
        addString += "UserName:" + UserDefaultCache.getUsername()! + "\n"
        addString += "UserPhone:" + phoneText.text! + "\n"
        addString += "AppVersion:" + BestRemoteFacade.appVersion + "\n"
        addString += "DeviceName:" + UIDevice.currentDevice().name + "\n"
        if UIDevice.currentDevice().identifierForVendor != nil{
            addString += "DeviceIdentifier:" + UIDevice.currentDevice().identifierForVendor!.debugDescription + "\n"
        }
        addString += "DeviceSystemVersion:iOS " + UIDevice.currentDevice().systemVersion + "\n"
        addString += "PhoneType:" + DeviceUtil.getCurrentDeviceModel() + "\n"
        addString += "LocalizedModel:" + UIDevice.currentDevice().localizedModel + "\n"
//        print(addString)
        return detailTextView.text + addString
    }

    func cancelClick(){
        self.navigationController?.popViewControllerAnimated(true)
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
