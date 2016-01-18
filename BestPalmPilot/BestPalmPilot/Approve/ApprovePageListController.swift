//
//  ApprovePageListController.swift
//  BestPalmPilot
//
//  Created by admin on 16/1/18.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit

class ApprovePageListController: PageListTableViewController {

    override func createPageSO() -> PageListSO {
        return FormListSO()
    }
    
    override func headerRequest(pageSO: PageListSO, callback: (() -> Void)!) {
        let fso = generateFormListSO(pageSO)
        BestRemoteFacade.getListFormInfos(fso,groupkey: approveMenuVo.groupkey){[unowned self] (json,var isSuccess,_) -> Void in
            if isSuccess {
                print(json)
            }
        }
    }
    
    private func generateFormListSO(pageSO:PageListSO)->FormListSO{
        let fso = pageSO as! FormListSO
        fso.code = approveMenuVo.code
        fso.token = UserDefaultCache.getToken()!
        fso.userName = UserDefaultCache.getUsercode()!
        return fso
    }
    
    override func footerRequest(pageSO: PageListSO, callback: ((hasData: Bool) -> Void)!) {
        let fso = generateFormListSO(pageSO)
        
    }
    
    var approveMenuVo:ApproveMenuVo!
    
    private func initTitleArea(){
        let leftItem = UIBarButtonItem(title: "嘿嘿", style: UIBarButtonItemStyle.Done, target: self, action: "cancelClick")
        let customView = UIArrowView(frame:CGRectMake(0, 0, 10, 22))
        customView.direction = .LEFT
        customView.lineColor = UIColor.whiteColor()
        customView.lineThinkness = 2
        leftItem.customView = customView
        customView.addTarget(self, action: "cancelClick", forControlEvents: UIControlEvents.TouchDown)
        
        let tabItem1 = UIFlatImageTabItem()
        tabItem1.frame = CGRectMake(0, 0, 30, 24)
        tabItem1.sizeType = .FillWidth
        tabItem1.normalColor = UIColor.whiteColor()
        //        tabItem.selectColor = UICreaterUtils.colorRise
        BatchLoaderUtil.loadFile("magnifie", callBack: { (image, params) -> Void in
            tabItem1.image = image
        })
        tabItem1.addTarget(self, action: "searchClick", forControlEvents: UIControlEvents.TouchDown)
        let rightItem1 =
        UIBarButtonItem(title: "嘿嘿", style: UIBarButtonItemStyle.Done, target: self, action: "searchClick")
        rightItem1.customView = tabItem1
        
        let tabItem2 = UIFlatImageTabItem()
        tabItem2.frame = CGRectMake(0, 0, 30, 24)
        tabItem2.sizeType = .FillWidth
        tabItem2.normalColor = UIColor.whiteColor()
        //        tabItem.selectColor = UICreaterUtils.colorRise
        BatchLoaderUtil.loadFile("campaign", callBack: { (image, params) -> Void in
            tabItem2.image = image
        })
        tabItem2.addTarget(self, action: "setupClick", forControlEvents: UIControlEvents.TouchDown)
        let rightItem2 =
        UIBarButtonItem(title: "嘿嘿", style: UIBarButtonItemStyle.Done, target: self, action: "setupClick")
        rightItem2.customView = tabItem2
        
        self.navigationItem.leftBarButtonItem = leftItem
        //        self.navigationItem.rightBarButtonItem = rightItem
        self.navigationItem.rightBarButtonItems = [rightItem2,rightItem1]
        
        let title = "申请审核"
        
        self.title = title
        
        self.view.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        
        let titleView = UIView()
        let label:UILabel = UICreaterUtils.createLabel(20, UIColor.whiteColor(), title, true, titleView)
        label.font = UIFont.systemFontOfSize(20)//20号 ,weight:2
        
        titleView.addSubview(label)
        label.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(titleView)
        }
        
        self.navigationItem.titleView = titleView
    }
    
    override func viewDidLoad() {
        initTitleArea()
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func cancelClick(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func searchClick(){
//        self.navigationController?.pushViewController(SearchViewController(), animated: true)
    }
    
    func setupClick(){
        self.drawerController.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: { _ -> Void in
            
        })
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
class FormListSO:PageListSO{

    var code:String = ""
    var token:String = ""
    var userName:String = ""
    
}
