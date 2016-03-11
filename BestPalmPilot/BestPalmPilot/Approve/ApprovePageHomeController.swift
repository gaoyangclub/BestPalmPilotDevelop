//
//  ApprovePageHomeController.swift
//  BestPalmPilot
//
//  Created by admin on 16/1/15.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit

class ApprovePageHomeController: PageListTableViewController {

    lazy private var searchBar:UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "请输入审批信息"
        
        BatchLoaderForSwift.loadFile("empty", callBack: { (image) -> Void in
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
    
    private lazy var rightItem:UIBarButtonItem = {
        let imageContainer = UIControl()
        imageContainer.frame = CGRectMake(0, 0, 30, 24)
        
        let tabItem2 = UIImageView()//UIFlatImageTabItem()
        imageContainer.addSubview(tabItem2)
        tabItem2.snp_makeConstraints{ (make) -> Void in
            make.left.right.top.bottom.equalTo(imageContainer)
        }
        
        tabItem2.contentMode = UIViewContentMode.ScaleAspectFit
        //        tabItem2.sizeType = .FillWidth
        //        tabItem2.normalColor = BestUtils.themeColor
        //        tabItem.selectColor = UICreaterUtils.colorRise
        BatchLoaderForSwift.loadFile("campaign", callBack: { (image) -> Void in
            tabItem2.image = image
        })
        
        imageContainer.addTarget(self, action: "setupClick", forControlEvents: UIControlEvents.TouchDown)
        let buttonItem =
        UIBarButtonItem(title: "嘿嘿", style: UIBarButtonItemStyle.Done, target: self, action: "setupClick")
        buttonItem.customView = imageContainer
        
        return buttonItem
    }()
    
    private lazy var titleView:UIView = UIView()
    private lazy var titleLabel:UILabel = BestUtils.createNavigationTitleLabel(self.titleView)
    
    private func initTitleArea(){
        self.view.backgroundColor = BestUtils.backgroundColor//UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1)
        self.tabBarController?.navigationItem.leftBarButtonItem = nil
        self.tabBarController?.navigationItem.rightBarButtonItem = rightItem
        //        self.tabBarController?.navigationItem.titleView = searchBar
        self.tabBarController?.navigationItem.titleView = titleView
        titleLabel.text = "审批管家"
    }
    
    //拉开抽屉设置(登入登出等)
    func setupClick(){
        self.drawerController.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: { _ -> Void in
            
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        showFooter = false
        
        super.viewWillAppear(animated)
        initTitleArea()
//        if hasSetUp {
//            self.refreshContaner.scrollerView.contentOffset.y = 0
//        }
    }
    
//    private var hasSetUp:Bool = false
//    func setupRefresh(){
//        self.refreshContaner.addHeaderWithCallback(RefreshHeaderView.header(),callback: {
//
//            BestRemoteFacade.getApproveMenu(UserDefaultCache.getUsername()!, callBack: { [weak self](json, isSuccess, error) -> Void in
//                if self == nil{
//                    print("ApprovePageHomeController对象已经销毁")
//                    return
//                }
//                if isSuccess{
//                    self?.hasSetUp = true
//                    
//                    let menuList:[ApproveMenuVo] = self!.generateApproveMenuList(json!.arrayValue)
//                    BestUtils.badgeCount = self!.getSystemBadgeCount(menuList)
//                    
//                    self?.dataSource.removeAllObjects()
//                    let approvePageSource = self!.getApprovePageSource(menuList)
//                    for i in 0..<approvePageSource.count{
//                        self?.dataSource.addObject(approvePageSource[i])
//                    }
//                    self?.tableView.reloadData()
//                    self?.refreshContaner.headerReset()
//                }
//            })
//        })
//    }
    
    override func headerRequest(pageSO: PageListSO?, callback: ((hasData: Bool,lastUpdateTime:String) -> Void)!) {
        BestRemoteFacade.getApproveMenu(UserDefaultCache.getUsercode()!, callBack: { [weak self](json, isSuccess, error) -> Void in
            if self == nil{
                print("ApprovePageHomeController对象已经销毁")
                return
            }
            if isSuccess{
                var hasData = true
//                print(json)
                if json!.arrayValue.count > 0{
                    let menuList:[ApproveMenuVo] = self!.generateApproveMenuList(json!.arrayValue)
                    BestUtils.badgeCount = self!.getSystemBadgeCount(menuList)
                    
                    self?.dataSource.removeAllObjects()
                    let approvePageSource = self!.getApprovePageSource(menuList)
                    for i in 0..<approvePageSource.count{
                        self?.dataSource.addObject(approvePageSource[i])
                    }
                }else{
                    hasData = false
                    BestUtils.badgeCount = 0
                }
                callback(hasData:hasData,lastUpdateTime:"")
            }else{
                callback(hasData:false,lastUpdateTime:"")
            }
        })
    }

    private func getSystemBadgeCount(menuList:[ApproveMenuVo])->Int{
        var count:Int = 0
        for avo in menuList {
//            avo.count = Int(arc4random_uniform(10) + 1)//  10
            count += avo.count
        }
        return count
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
        var index:Int = 0
        for json in jsonList{
            let avo = BestUtils.generateObjByJson(json,typeList: [ApproveMenuVo.self]) as! ApproveMenuVo
            avo.iconurl = "approve_tag0\(index++ % 2)"
//            print(avo.count)
            menuList.append(avo)
        }
        return menuList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewWillAppear(false)
        
//        self.setupRefresh()
//        self.refreshContaner.headerBeginRefreshing()
        // Do any additional setup after loading the view.
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
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
private class ApprovePageHomeInfoCell: BaseTableViewCell {
    
    static let cellHeight:CGFloat = 70
    
    override func showSubviews(){
        self.selectionStyle = UITableViewCellSelectionStyle.None
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
        let label = UICreaterUtils.createLabel(18, FlatUIColors.ebonyClayColor(), "", true, self.contentView)
        return label
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UICreaterUtils.createLabel(16, UICreaterUtils.colorFlat, "", true, self.contentView)
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
    
//    private lazy var iconView:UIFlatImageTabItem = {
//        let tabItem = UIFlatImageTabItem()
//        self.contentView.addSubview(tabItem)
//        tabItem.userInteractionEnabled = false
//        tabItem.sizeType = .FillWidth
//        tabItem.normalColor = BestUtils.deputyColor//UICreaterUtils.colorRise
//        return tabItem
//    }()
    
    private lazy var iconView:UIImageView = {
        let tabItem = UIImageView()
        self.contentView.addSubview(tabItem)
        tabItem.contentMode = UIViewContentMode.ScaleAspectFit
        return tabItem
    }()
    
//    private lazy var badgeView:CustomBadge = {
//        let badge = CustomBadge(string: "1",withScale: 1.2)
//        badge.badgeStyle.badgeInsetColor = FlatUIColors.alizarinColor()
//        self.contentView.addSubview(badge)
//        return badge
//    }()
    private lazy var tagView:RoundTagView = {
        let tag = RoundTagView()
        tag.showBorder = false
        tag.showBack = true
        tag.tagSize = 20
        tag.cornerRadius = 14
        tag.minTagWidth = 28
        tag.minTagHeight = 28
        tag.tagColor = UIColor.whiteColor()
        tag.backColor = FlatUIColors.alizarinColor()
        self.contentView.addSubview(tag)
        
        tag.snp_makeConstraints { [weak self](make) -> Void in
            make.right.equalTo(self!.arrowView.snp_left).offset(-16)
            make.centerY.equalTo(self!.contentView)
        }
        return tag
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
            make.width.equalTo(60)
            make.height.equalTo(40)
            make.centerY.equalTo(self!.contentView)
        }
        BatchLoaderForSwift.loadFile(avo.iconurl, callBack: { [weak self](image) -> Void in
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
            make.top.equalTo(self!.contentView.snp_centerY).offset(4)
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
        
        avo.countProxy?.observe({ [weak self] value -> Void in
            if value > 0{
                self?.tagView.hidden = false
                
//                self?.badgeView.badgeText = "\(value)"
//                self?.badgeView.autoBadgeSizeWithString("\(value)")//
                self?.tagView.tagText = "\(value)"
                //            print("个数:\(avo.count)" + " ---  badgeView.badgeText:" + badgeView.badgeText)
            }else{
                self?.tagView.hidden = true
            }
        })
    }
    
}
public class ApproveMenuVo:NSObject{
    
    override init() {
        super.init()
        self.countProxy = Observable<Int>(object:self, keyPath: "count")
    }
    var iconurl:String = ""
    var code:String = ""
    var sortindex:Int = 0 //排序
    var groupkey:String = "" //系统类型
    var groupname:String = "" //系统名称描述
    var count:Int = 0{
        didSet{
            countProxy?.value = count//更新数据
        }
    }//Observable(0) //待处理条数
    var countProxy:Observable<Int>?// = Observable<Int>(object:self, keyPath: "value")

}



