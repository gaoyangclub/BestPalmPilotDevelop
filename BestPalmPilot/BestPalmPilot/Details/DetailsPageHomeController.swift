//
//  DetailsPageController.swift
//  BestPalmPilot
//
//  Created by admin on 16/1/19.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit

@objc public protocol DetailsPageDelegate {
    // MARK: - Delegate functions
    optional func getFormDetails(refresh:Bool,formKey:String,callback:(([FormDetailVo]) -> Void)!)
//    optional func getFormInfoVo()->FormInfoVo?
}
public class DetailsPageHomeController: UIViewController,UITextFieldDelegate,DetailsPageDelegate {

//    var approveMenuVo:ApproveMenuVo!
    var groupkey:String!
    var formInfoVo:FormInfoVo!
    
    var formWholeVo:FormWholeVo? //该界面所有列表的数据源
    
    private lazy var titleView:UIView = UIView()
    private lazy var titleLabel:UILabel = BestUtils.createNavigationTitleLabel(self.titleView)
    
    private lazy var leftItem:UIBarButtonItem = BestUtils.createNavigationLeftButtonItem(self,action: "cancelClick")
    
    private lazy var rightItem:UIBarButtonItem = {
        let tabItem2 = UIFlatImageTabItem()
        tabItem2.frame = CGRectMake(0, 0, 30, 24)
        tabItem2.sizeType = .FillWidth
        tabItem2.normalColor = UIColor.whiteColor()
        //        tabItem.selectColor = UICreaterUtils.colorRise
        BatchLoaderUtil.loadFile("campaign", callBack: { (image, params) -> Void in
            tabItem2.image = image
        })
        tabItem2.addTarget(self, action: "setupClick", forControlEvents: UIControlEvents.TouchDown)
        let item =
        UIBarButtonItem(title: "嘿嘿", style: UIBarButtonItemStyle.Done, target: self, action: "setupClick")
        item.customView = tabItem2
        return item
    }()
    
    private func initTitleArea(){
        self.navigationItem.leftBarButtonItem = leftItem
        self.navigationItem.rightBarButtonItem = rightItem
        self.navigationItem.titleView = titleView
        self.title = "申请明细"
        titleLabel.text = self.title
        
        self.view.backgroundColor = BestUtils.backgroundColor
    }
    
    private static let BOTTOM_HEIGHT:CGFloat = 150
    
    private lazy var bottomView:UIView = {
        let view = UIView()
        self.view.addSubview(view)

        view.backgroundColor = BestUtils.backgroundColor
        view.snp_makeConstraints(closure: {[weak self] (make) -> Void in
            make.left.right.bottom.equalTo(self!.view)
//            make.top.equalTo(self!.opinionText).offset(-6)
            make.height.equalTo(DetailsPageHomeController.BOTTOM_HEIGHT)
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
    
    private lazy var opinionText:UITextField = {
        let view = UIView()
        view.layer.borderColor = UICreaterUtils.colorFlat.CGColor
        view.layer.borderWidth = 1//UICreaterUtils.normalLineWidth
        view.layer.cornerRadius = 2
        view.backgroundColor = UIColor.whiteColor()
        self.bottomView.addSubview(view)
        
        view.snp_makeConstraints { [weak self](make) -> Void in
            make.left.right.height.equalTo(self!.agreeButton)
            make.bottom.equalTo(self!.agreeButton.snp_top).offset(-8)
        }
        
        let text = UITextField()
        text.clearButtonMode = UITextFieldViewMode.WhileEditing
        text.textColor = UICreaterUtils.colorBlack
        view.addSubview(text)
        text.placeholder = "申请意见"
        text.returnKeyType = UIReturnKeyType.Done
        
        text.snp_makeConstraints {(make) -> Void in
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view).offset(-5)
            make.top.bottom.equalTo(view)
        }
        return text
    }()
    
    private lazy var agreeButton:UIButton = {
        let btn = UIButton(type: UIButtonType.System)
        btn.layer.cornerRadius = 2
        let normalColor:UIColor = BestUtils.themeColor
        btn.backgroundColor = normalColor
        let title:NSString = "同  意"
        btn.setTitle(title as String, forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.bottomView.addSubview(btn)
        
        btn.snp_makeConstraints { [weak self](make) -> Void in
            make.left.right.height.equalTo(self!.rejectButton)
            make.bottom.equalTo(self!.rejectButton.snp_top).offset(-6)
        }
        
        btn.titleLabel?.font = UIFont.systemFontOfSize(18)//weight文字线条粗细 ,weight:2
        return btn
    }()
    
    private lazy var rejectButton:UIButton = {
        let btn = UIButton(type: UIButtonType.System)
        btn.layer.cornerRadius = 2
        let normalColor:UIColor = BestUtils.themeColor
        btn.backgroundColor = normalColor
        let title:NSString = "退  回"
        btn.setTitle(title as String, forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.bottomView.addSubview(btn)
        
        btn.snp_makeConstraints { [weak self](make) -> Void in
            make.left.equalTo(self!.bottomView).offset(20)
            make.right.equalTo(self!.bottomView).offset(-20)
            make.height.equalTo(40)
            make.bottom.equalTo(self!.bottomView).offset(-6)
        }
        
        btn.titleLabel?.font = UIFont.systemFontOfSize(18)//weight文字线条粗细 ,weight:2
        return btn
    }()
    
    //键盘按return键返回
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()//取消第一响应
        return true
    }
    
    private func initBottomArea(){
        opinionText.delegate = self
        rejectButton.addTarget(self, action: "rejectClick:", forControlEvents: UIControlEvents.TouchUpInside)
        agreeButton.addTarget(self, action: "agreeClick:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        initTitleArea()
        initMenuArea()
        initBottomArea()
        // Do any additional setup after loading the view.
    }
    
    private var pageMenu:CAPSPageMenu!
    private var selectedIndex:Int = 0
    private func initMenuArea(){
        if pageMenu == nil{
            
            let titleList = [("基本信息","formheaders"),("明细信息","formdetails")]
            var controllerArray:[UIViewController] = []
            for title in titleList{
                let controller:DetailsPageInfoController = DetailsPageInfoController()
                controller.title = title.0
                controller.formKey = title.1
                controller.delegate = self
                controllerArray.append(controller)
            }
            
            let itemWidth = self.view.frame.width / 2 - 10
            let parameters: [CAPSPageMenuOption] = [
                .MenuHeight(45),
                .MenuItemWidth(itemWidth),
                .MenuMargin(0),
                //                CAPSPageMenuOption.MenuItemWidthBasedOnTitleTextWidth(true),
                .ScrollMenuBackgroundColor(UIColor.clearColor()),
                .ViewBackgroundColor(UIColor.clearColor()),
                CAPSPageMenuOption.SelectionIndicatorColor(BestUtils.deputyColor),
                //            CAPSPageMenuOption.MenuItemSeparatorColor(UIColor.orangeColor()),
                //            .BottomMenuHairlineColor(UIColor.grayColor()),
                //            .UseMenuLikeSegmentedControl(true),
                //            .MenuItemSeparatorPercentageHeight(0.5),
                .UnselectedMenuItemLabelColor(UICreaterUtils.colorBlack),
                .SelectedMenuItemLabelColor(BestUtils.deputyColor),
                CAPSPageMenuOption.MenuItemSeparatorUnderline(true),
                .MenuItemFont(UIFont.systemFontOfSize(20)),//,weight:1.2
                .SelectionIndicatorHeight(2),
                .CenterMenuItems(true),
                .AddBottomMenuHairline(false)
            ]
            pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame:CGRectMake(0,0,self.view.frame.width,0),pageMenuOptions: parameters)
            // frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height - DetailsPageHomeController.BOTTOM_HEIGHT)
            //        pageMenu.currentPageIndex = selectedIndex
            //        pageMenu.moveToPage(selectedIndex)
            self.view.addSubview(pageMenu!.view)
        }
//        pageMenu.moveToPage(selectedIndex)//动作切换完毕
        pageMenu.view.snp_makeConstraints { [weak self](make) -> Void in
            make.left.right.top.equalTo(self!.view)
//            make.top.equalTo(self!.view).offset(10)
//            make.left.equalTo(self!.view).offset(50)
//            make.right.equalTo(self!.view).offset(-50)
            make.bottom.equalTo(self!.bottomView.snp_top)
        }
    }
    
    public func getFormDetails(refresh:Bool,formKey: String, callback: (([FormDetailVo]) -> Void)!) {
        if refresh || self.formWholeVo == nil{
            pageMenu.view.userInteractionEnabled = false //暂时屏蔽交互
            BestRemoteFacade.getFormDetailsVo(formInfoVo.code, groupkey: self.groupkey, callBack: { [weak self](json, isSuccess, error) -> Void in
                if self == nil{
                    print("DetailsPageHomeController对象已经销毁")
                    return
                }
                if isSuccess{
                    self?.formWholeVo = BestUtils.generateObjByJson(json!, typeList: [FormWholeVo.self,FormDetailVo.self,FormContentVo.self]) as? FormWholeVo
                    self?.pageMenu.view.userInteractionEnabled = true //交互恢复
                    self?.getFormCallBack(formKey,callback: callback)
                }
            })
        }else{ //直接拿数据
            getFormCallBack(formKey,callback: callback)
        }
    }
    /** 获取订单信息数据 **/
    public func getFormInfoVo() -> FormInfoVo? {
        return self.formInfoVo
    }
    
    private func getFormCallBack(formKey: String, callback: (([FormDetailVo]) -> Void)!){
        let dataList:AnyObject? = self.formWholeVo?.valueForKey(formKey)
        if dataList != nil && dataList is [FormDetailVo]{
            callback(dataList as! [FormDetailVo])
        }
    }
    
    func rejectClick(sender:UIButton){
        if opinionText.text == nil || opinionText.text!.isEmpty {
            JLToast.makeText("请先输入申请意见!").show()
            return
        }
        BestUtils.showAlert(message:"确定退回该AP吗？",parentController:self){ [weak self] _ -> Void in
            EZLoadingActivity.show("AP退回中", disableUI: true)
            self!.submitAction(BestUtils.AUDIT_APPROVE,callBack:self!.getAuditResult)//{ [weak self] json,isSuccess,error in
        }
    }
    
    private func getAuditResult(json:JSON?,isSuccess:Bool,error:NSError?)->Void{
        EZLoadingActivity.hide()
        if isSuccess {
            let resultVo = BestUtils.generateObjByJson(json!, type: AuditResultVo.self) as! AuditResultVo
            if resultVo.result {
                self.checkPrevPageListController()
            }else{
                BestUtils.showAlert("审批失败",message:resultVo.reason, parentController: self, useCancel:false,okHandler: {[weak self]  (_) -> Void in
                    self!.checkPrevPageListController()//必须回传后页面可以交互
                    })
            }
        }else{
            BestUtils.showAlert("审批失败",message:error!.debugDescription, parentController: self, useCancel:false,okHandler: {[weak self]  (_) -> Void in
                self!.checkPrevPageListController()//必须回传后页面可以交互
            })
        }
    }
    
    func agreeClick(sender:UIButton){
        BestUtils.showAlert(message:"确定同意该AP吗？",parentController:self){ [weak self] _ -> Void in
            EZLoadingActivity.show("AP审批中", disableUI: true)
            self!.submitAction(BestUtils.AUDIT_REJECT,callBack:self!.getAuditResult)
//                { [weak self] json in
//                //必须回传后页面可以交互
//                self!.checkPrevPageListController()
//                EZLoadingActivity.hide()
//            }
        }
    }
    
    private func checkPrevPageListController(){
        let vcCount = self.rootNavigationController.viewControllers.count
        if vcCount - 2 >= 0 {
            let vc = self.rootNavigationController.viewControllers[vcCount - 2] //获取前一个vc
            if vc is ApprovePageListController{
                (vc as! ApprovePageListController).deleteRowsByFormInfoVo(self.formInfoVo)
            }
            self.cancelClick()//返回上一级
        }
    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let searchIndex = self.rootNavigationController.viewControllers.count - 2
        //        var viewControllers:[AnyObject] = self.navigationController!.viewControllers
        if (self.rootNavigationController.viewControllers[searchIndex] as? SearchViewController != nil){//上一层是SearchViewController就要移除掉
            self.rootNavigationController.viewControllers.removeAtIndex(searchIndex)
        }
    }
    
    private func submitAction(action:String,callBack:ResponseCompletionHandler? = nil){
        //username: UserDefaultCache.getUsername()!
        BestRemoteFacade.audit(formInfoVo.code, action: action, remark: opinionText.text!, userCode: UserDefaultCache.getUsercode()!, groupkey: self.groupkey, callBack: callBack)
    }
    
    func cancelClick(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setupClick(){
        self.drawerController.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: { _ -> Void in
            
        })
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
public class FormWholeVo:NSObject{
    var id:String = ""
    var formdetails:[FormDetailVo] = []
    var formheaders:[FormDetailVo] = []
    var key:String = ""
    var code:String = ""
}
public class FormDetailVo:NSObject{
    var content:[FormContentVo] = []
    var sortindex:Int = 0
    var title:String = ""
}
public class FormContentVo:NSObject{
    var fieldcontent:String = ""
    var fieldname:String = ""
    var order:Int = 0
}
public class AuditResultVo:NSObject{
    var code:String = ""
    var reason:String = ""
    var result:Bool = true
}


