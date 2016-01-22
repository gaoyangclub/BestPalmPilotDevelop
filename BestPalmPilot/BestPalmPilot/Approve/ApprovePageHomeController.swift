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
        self.navigationController?.pushViewController(SearchViewController(), animated: true)
        //跳转到搜索页面
    }
    
    private func initTitleArea(){
        let tabItem2 = UIFlatImageTabItem()
        tabItem2.frame = CGRectMake(0, 0, 30, 24)
        tabItem2.sizeType = .FillWidth
        tabItem2.normalColor = UIColor.whiteColor()
        //        tabItem.selectColor = UICreaterUtils.colorRise
        BatchLoaderUtil.loadFile("campaign", callBack: { (image, params) -> Void in //[weak self]
            tabItem2.image = image
        })
        tabItem2.addTarget(self, action: "setupClick", forControlEvents: UIControlEvents.TouchDown)
        let rightItem =
        UIBarButtonItem(title: "嘿嘿", style: UIBarButtonItemStyle.Done, target: self, action: "setupClick")
        rightItem.customView = tabItem2
        
        self.view.backgroundColor = BestUtils.backgroundColor//UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1)
        
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
        self.tabBarController?.navigationItem.rightBarButtonItem = rightItem
//        self.tabBarController?.navigationItem.titleView = searchBar
        
        let title = "审批管家"
        self.tabBarController?.title = title
        let titleView = UIView()
        let label:UILabel = UICreaterUtils.createLabel(20, UIColor.whiteColor(), title, true, titleView)
        label.font = UIFont.systemFontOfSize(20)//20号 ,weight:2
        
        titleView.addSubview(label)
        label.snp_makeConstraints { (make) -> Void in //[weak self]
            make.center.equalTo(titleView)
        }
        
        self.tabBarController?.navigationItem.titleView = titleView
    }
    
    //拉开抽屉设置(登入登出等)
    func setupClick(){
        self.drawerController.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: { _ -> Void in
            
        })
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

            BestRemoteFacade.getApproveMenu(UserDefaultCache.getUsername()!, callBack: { [weak self](json, isSuccess, error) -> Void in
                if self == nil{
                    print("ApprovePageHomeController对象已经销毁")
                    return
                }
                if isSuccess{
                    
                    let menuList:[ApproveMenuVo] = self!.generateApproveMenuList(json!.arrayValue)
                    
                    self?.hasSetUp = true
                    
                    self?.dataSource.removeAllObjects()
                    let approvePageSource = self!.getApprovePageSource(menuList)
                    for i in 0..<approvePageSource.count{
                        self?.dataSource.addObject(approvePageSource[i])
                    }
                    self?.tableView.reloadData()
                    self?.refreshContaner.headerReset()
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
        var index:Int = 1
        for json in jsonList{
            let avo = BestUtils.generateObjByJson(json,typeList: [ApproveMenuVo.self]) as! ApproveMenuVo
            avo.iconurl = "fundTag0\(index++)"
            menuList.append(avo)
        }
        return menuList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTitleArea()
        
        self.setupRefresh()
        self.refreshContaner.headerBeginRefreshing()
        // Do any additional setup after loading the view.
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let section = indexPath.section
        let source = dataSource[section] as! SoueceVo
        let cell:CellVo = source.data![indexPath.row] as! CellVo
        if cell.cellData is ApproveMenuVo{
            //点击hot内容跳转
            let avo = cell.cellData as! ApproveMenuVo //点击到Fund详细页
            let pageKindController = ApprovePageListController()
            pageKindController.approveMenuVo = avo
            self.navigationController?.pushViewController(pageKindController, animated: true)
        }
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
        self.selectionStyle = UITableViewCellSelectionStyle.Gray
        self.contentView.backgroundColor = UIColor.whiteColor()
        initCell()
    }
    
    private lazy var bottomLine:UIView = {
        let view:UIView = UIView()
        view.backgroundColor = UICreaterUtils.normalLineColor
        self.contentView.addSubview(view)
        return view
    }()
    
    
    private lazy var tagLabel:UILabel = {
        let label = UICreaterUtils.createLabel(26, FlatUIColors.ebonyClayColor(), "", true, self.contentView)
        return label
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UICreaterUtils.createLabel(18, UICreaterUtils.colorFlat, "", true, self.contentView)
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
        arrow.lineColor = UICreaterUtils.normalLineColor
        arrow.lineThinkness = 2
        return arrow
    }()
    
    private lazy var iconView:UIFlatImageTabItem = {
        let tabItem = UIFlatImageTabItem()
        self.contentView.addSubview(tabItem)
        tabItem.userInteractionEnabled = false
        tabItem.sizeType = .FillWidth
        tabItem.normalColor = BestUtils.deputyColor//UICreaterUtils.colorRise
        return tabItem
    }()
    
    private lazy var badgeView:CustomBadge = {
        let badge = CustomBadge(string: "1",withScale: 1.2)
        badge.badgeStyle.badgeInsetColor = FlatUIColors.alizarinColor()
        self.contentView.addSubview(badge)
        return badge
    }()
    
    private func initCell(){
        let avo:ApproveMenuVo = data as! ApproveMenuVo
        
        bottomLine.snp_makeConstraints { [weak self](make) -> Void in
            make.left.right.bottom.equalTo(self!.contentView)
            make.height.equalTo(UICreaterUtils.normalLineWidth)
        }
        
        iconView.snp_makeConstraints { [weak self](make) -> Void in
            make.left.equalTo(self!.contentView).offset(2)
            //            make.size.equalTo(CGSize(width: 40, height: 24))
            make.width.equalTo(40)
            make.height.equalTo(24)
            make.centerY.equalTo(self!.tagLabel)
        }
        BatchLoaderUtil.loadFile(avo.iconurl, callBack: { [weak self](image, params) -> Void in
            self!.iconView.image = image
        })
        
        tagLabel.snp_makeConstraints { [weak self](make) -> Void in
            make.left.equalTo(self!.iconView.snp_right).offset(10)
            make.bottom.equalTo(self!.contentView.snp_centerY)
        }
        
        tagLabel.text = avo.groupkey
        tagLabel.sizeToFit()
        
        titleLabel.snp_makeConstraints { [weak self](make) -> Void in
            make.left.equalTo(self!.tagLabel)
            make.top.equalTo(self!.contentView.snp_centerY).offset(6)
        }
        self.titleLabel.text = avo.groupname
        self.titleLabel.sizeToFit()
        
        arrowView.snp_makeConstraints { [weak self](make) -> Void in
            make.width.equalTo(10)
            make.height.equalTo(22)
            make.centerY.equalTo(self!.contentView)
            make.right.equalTo(self!.contentView).offset(-30)
        }
//        avo.count = 88
        if avo.count > 0{
            badgeView.hidden = false
            badgeView.badgeText = "\(avo.count)"
            
            badgeView.snp_makeConstraints { [weak self](make) -> Void in
                make.right.equalTo(self!.arrowView.snp_left).offset(-16)
                make.centerY.equalTo(self!.contentView)
                make.width.equalTo(34)
                make.height.equalTo(34)
            }
        }else{
            badgeView.hidden = true
        }
        
    }
    
}
public class ApproveMenuVo:NSObject{
    var iconurl:String = ""
    var code:String = ""
    var sortindex:Int = 0 //排序
    var groupkey:String = "" //系统类型
    var groupname:String = "" //系统名称描述
    var count:Int = 0 //待处理条数
}



