//
//  ApprovePageHomeController.swift
//  BestPalmPilot
//
//  Created by admin on 16/1/15.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit

class ApprovePageHomeController: BaseTableViewController {

    lazy private var searchBar:UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "请输入审批信息"
        
        BatchLoaderUtil.loadFile("empty", callBack: { (image, params) -> Void in
            bar.backgroundImage = image // 需要用1像素的透明图片代替背景图 不然动画交互的时候会坑爹的闪现灰底
        })
        
        var topView: UIView = bar.subviews[0]
        topView.userInteractionEnabled = false
        
        var atap = UITapGestureRecognizer(target: self, action: "searchBarTap:")
        atap.numberOfTapsRequired = 1//单击
        bar.addGestureRecognizer(atap)
        
        return bar
    }()
    
    func searchBarTap(target:AnyObject){
//        self.navigationController?.pushViewController(SearchViewController(), animated: true)
        //跳转到搜索页面
    }
    
    private func initTitleArea(){
        let tabItem2 = UIFlatImageTabItem()
        tabItem2.frame = CGRectMake(0, 0, 30, 24)
        tabItem2.sizeType = .FillWidth
        tabItem2.normalColor = UIColor.whiteColor()
        //        tabItem.selectColor = UICreaterUtils.colorRise
        BatchLoaderUtil.loadFile("campaign", callBack: { (image, params) -> Void in
            tabItem2.image = image
        })
//        tabItem2.addTarget(self, action: "setupClick", forControlEvents: UIControlEvents.TouchDown)
        let rightItem =
        UIBarButtonItem(title: "嘿嘿", style: UIBarButtonItemStyle.Done, target: self, action: "setupClick")
        rightItem.customView = tabItem2
        
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
        self.tabBarController?.navigationItem.rightBarButtonItem = rightItem
        self.tabBarController?.navigationItem.titleView = searchBar
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initTitleArea()
        
        if hasSetUp {
            self.refreshContaner.scrollerView.contentOffset.y = 0
        }
    }
    
    private var hasSetUp:Bool = false
    func setupRefresh(){
        self.refreshContaner.addHeaderWithCallback(RefreshHeaderView.header(),callback: {

            BestRemoteFacade.getApproveMenu(UserDefaultCache.getUsername()!, callBack: { [unowned self](json, isSuccess, error) -> Void in
                if isSuccess{
                    
                    let menuList:[ApproveMenuVo] = self.generateApproveMenuList(json!.arrayValue)
                    
                    self.hasSetUp = true
                    
                    self.dataSource.removeAllObjects()
                    let approvePageSource = self.getApprovePageSource(menuList)
                    for i in 0..<approvePageSource.count{
                        self.dataSource.addObject(approvePageSource[i])
                    }
                    self.tableView.reloadData()
                    self.refreshContaner.headerReset()
                }
            })
        })
    }
    
    private func getApprovePageSource(menuList:[ApproveMenuVo])->NSMutableArray{
        let svo = SoueceVo(data: [
            CellVo(cellHeight: ApprovePageHomeHotCell.cellHeight, cellClass: ApprovePageHomeHotCell.self)
            ])
        for avo in menuList{
            svo.data?.addObject(CellVo(cellHeight: ApprovePageHomeInfoCell.cellHeight, cellClass: ApprovePageHomeInfoCell.self,cellData:avo))
        }
        return [svo]
    }
    
    private func generateApproveMenuList(jsonList:[JSON])->[ApproveMenuVo]{
        var menuList:[ApproveMenuVo] = []
        for json in jsonList{
            let avo = BestUtils.generateObjByJson(json,classType: ApproveMenuVo.self) as! ApproveMenuVo
            menuList.append(avo)
        }
        return menuList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1)
        
        self.setupRefresh()
        self.refreshContaner.headerBeginRefreshing()
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
class ApproveHotVo{
    init(icon:String,title:String,link:String){
        self.icon = icon
        self.title = title
        self.link = link
    }
    var icon:String!
    var title:String!
    var link:String!
}
private class ApprovePageHomeInfoCell: BaseTableViewCell {
    
    static let cellHeight:CGFloat = 80
    
    override func showSubviews(){
        self.contentView.backgroundColor = UIColor.whiteColor()
        initCell()
    }
    
    private lazy var bottomLine:UIView = {
        let view:UIView = UIView()
        view.backgroundColor = UICreaterUtils.normalLineColor
        self.contentView.addSubview(view)
        return view
    }()
    
    
    private lazy var titleLabel:UILabel = {
        let label = UICreaterUtils.createLabel(18, UICreaterUtils.colorBlack, "", true, self.contentView)
        return label
    }()
    
    //    private lazy var rateLabel:UILabel = {
    //        let label = UICreaterUtils.createLabel(15, UIColor.grayColor(), "", true, self.contentView)
    //        //        label.font = UIFont.systemFontOfSize(14, weight: 1.05)
    //
    //        var tag = UICreaterUtils.createLabel(14, UIColor.grayColor(), "季度收益", true, self.contentView)
    //        tag.snp_makeConstraints{ (make) -> Void in
    //            make.right.equalTo(label.snp_left).offset(-6)
    //            make.centerY.equalTo(label)
    //        }
    //        return label
    //    }()
    
    
    private lazy var arrowView:UIArrowView = {
       let arrow = UIArrowView(frame:CGRectMake(0, 0, 10, 22))
        arrow.direction = .RIGHT
        self.contentView.addSubview(arrow)
        ////        customView.isClosed = true
        arrow.lineColor = UICreaterUtils.colorBlack
        arrow.lineThinkness = 2
        return arrow
    }()
    
    private lazy var iconView:UIFlatImageTabItem = {
        let tabItem = UIFlatImageTabItem()
        self.contentView.addSubview(tabItem)
        tabItem.userInteractionEnabled = false
        tabItem.sizeType = .FillWidth
        tabItem.normalColor = UICreaterUtils.colorRise
        return tabItem
    }()
    
    private func initCell(){
        let avo:ApproveMenuVo = data as! ApproveMenuVo
        
        self.bottomLine.snp_makeConstraints { [unowned self](make) -> Void in
            make.left.right.bottom.equalTo(self.contentView)
            make.height.equalTo(UICreaterUtils.normalLineWidth)
        }
        
        self.iconView.snp_makeConstraints { [unowned self](make) -> Void in
            make.left.equalTo(self.contentView).offset(2)
            //            make.size.equalTo(CGSize(width: 40, height: 24))
            make.width.equalTo(40)
            make.height.equalTo(24)
            make.centerY.equalTo(self.titleLabel)
        }
        BatchLoaderUtil.loadFile(avo.iconUrl, callBack: { [unowned self](image, params) -> Void in
            self.iconView.image = image
        })
        
        self.titleLabel.snp_makeConstraints { [unowned self](make) -> Void in
            make.left.equalTo(self.iconView.snp_right)
            make.centerY.equalTo(self.contentView)
        }
        
        arrowView.snp_makeConstraints { [unowned self](make) -> Void in
            make.width.equalTo(10)
            make.height.equalTo(22)
            make.centerY.equalTo(self.contentView)
            make.right.equalTo(self.contentView).offset(-30)
        }
        
        self.titleLabel.text = avo.groupname
        self.titleLabel.sizeToFit()
    }
    
}
public class ApproveMenuVo:NSObject{
    var iconUrl:String = ""
    var code:String = ""
    var sortindex:Int = 0 //排序
    var groupkey:String = "" //系统类型
    var groupname:String = "" //系统名称描述
    var count:Int = 0 //待处理条数
}



