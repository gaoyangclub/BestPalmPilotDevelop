//
//  HelpListViewController.swift
//  BestPalmPilot
//
//  Created by admin on 16/1/25.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit
import CoreLibrary

class HelpListViewController: PageListTableViewController {

    private lazy var titleView:UIView = UIView()
    private lazy var titleLabel:UILabel = BestUtils.createNavigationTitleLabel(self.titleView)
    
    private lazy var leftItem:UIBarButtonItem = BestUtils.createNavigationLeftButtonItem(self,action: "cancelClick")
    
    private lazy var rightItem:UIBarButtonItem = {
        let tabItem2 = UIFlatImageTabItem()
        tabItem2.frame = CGRectMake(0, 0, 30, 24)
        tabItem2.sizeType = .FillWidth
        tabItem2.normalColor = UIColor.whiteColor()
        //        tabItem.selectColor = UICreaterUtils.colorRise
        BatchLoaderForSwift.loadFile("campaign", callBack: { (image) -> Void in
            tabItem2.image = image
        })
        tabItem2.addTarget(self, action: "setupClick", forControlEvents: UIControlEvents.TouchDown)
        let item =
        UIBarButtonItem(title: "嘿嘿", style: UIBarButtonItemStyle.Done, target: self, action: "setupClick")
        item.customView = tabItem2
        return item
    }()
    
    private func initTitleArea(){
        
        self.navigationItem.rightBarButtonItem = rightItem
        self.navigationItem.leftBarButtonItem = leftItem
        self.navigationItem.titleView = titleView
        self.title = "申请帮助人信息"
        titleLabel.text = self.title
        
        self.view.backgroundColor = BestUtils.backgroundColor
    }
    
    override func headerRequest(pageSO: PageListSO?, callback: ((hasData: Bool,lastUpdateTime:String) -> Void)!) {
        BestRemoteFacade.getHelpInfo {[weak self]  (json, isSuccess, error) -> Void in
            if self == nil || self!.isDispose  {
                print("HelpListViewController对象已经销毁")
                return
            }
            if isSuccess {
//                print(json)
                var hasData = true
                if json!.arrayValue.count > 0{
                    let helpInfoList:[HelpInfoVo] = self!.generateHelpInfoList(json!.arrayValue)
                    self!.dataSource.removeAllObjects()
                    let helpInfoPageSource = self!.getHelpInfoPageSource(helpInfoList)
                    for i in 0..<helpInfoPageSource.count{
                        self!.dataSource.addObject(helpInfoPageSource[i])
                    }
                }else{
                    hasData = false
                }
                callback(hasData:hasData,lastUpdateTime:"")
            }
        }
    }
    
    
    private func generateHelpInfoList(jsonList:[JSON])->[HelpInfoVo]{
        var helpList:[HelpInfoVo] = []//
        for json in jsonList{
            let hvo = BestUtils.generateObjByJson(json, type: HelpInfoVo.self) as! HelpInfoVo
            helpList.append(hvo)
        }
        return helpList
    }
    
    private func getHelpInfoPageSource(infoList:[HelpInfoVo])->NSMutableArray{
        let  svo = SourceVo(data: []) //添加新的
        for avo in infoList{
            svo.data?.addObject(CellVo(cellHeight: HelpInfoPageCell.cellHeight, cellClass: HelpInfoPageCell.self,cellData:avo))
        }
        return [svo]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initTitleArea()
        // Do any additional setup after loading the view.
    }

    func cancelClick(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setupClick(){
        self.drawerController.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false) //反选
        
        let section = indexPath.section
        let source = dataSource[section] as! SourceVo
        let cell:CellVo = source.data![indexPath.row] as! CellVo
        if cell.cellData is HelpInfoVo{
            //点击hot内容跳转
            let hvo = cell.cellData as! HelpInfoVo //点击到Fund详细页
            BestUtils.showAlert(message: "确定拨打电话给" + hvo.name + "吗？", parentController: self, okHandler: {  _ in //[weak self]
                UIApplication.sharedApplication().openURL(NSURL(string: "tel:" + hvo.contact)!)
            })
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
class HelpInfoVo:NSObject{
    
//    var appversion:String = ""
    var contact:String = ""//联系方式等 邮件 短信 电话
    var name:String = ""
//    var updateurl:String = ""
    
}
class HelpInfoPageCell:BaseTableViewCell{

    static let cellHeight:CGFloat  = 60
    
    private lazy var iconBack:UIView = {
        let view = UIView()
        self.addSubview(view)
        let radius:CGFloat = 20
        view.layer.cornerRadius = radius
        view.backgroundColor = FlatUIColors.emeraldColor()
        view.snp_makeConstraints(closure: {[weak self] (make) -> Void in
            make.left.equalTo(self!.bottomLine)
            make.centerY.equalTo(self!.contentView)
            make.width.height.equalTo(radius * 2)
        })
        return view
    }()
    
    private lazy var iconView:UIFlatImageTabItem = {
        let tabItem = UIFlatImageTabItem()
        self.iconBack.addSubview(tabItem)
        tabItem.userInteractionEnabled = false
        tabItem.sizeType = .FillWidth
        tabItem.normalColor = UIColor.whiteColor()//UICreaterUtils.colorRise
        BatchLoaderForSwift.loadFile("phone", callBack: { [weak self](image) -> Void in
            tabItem.image = image
        })
        tabItem.snp_makeConstraints(closure: { [weak self](make) -> Void in //[weak self]
            make.center.equalTo(self!.iconBack)
            make.width.equalTo(40)
            make.height.equalTo(30)
        })
        return tabItem
    }()
    
    private lazy var topLine:UIView = {
        let view:UIView = UIView()
        view.backgroundColor = UICreaterUtils.normalLineColor
        self.contentView.addSubview(view)
        view.snp_makeConstraints { [weak self](make) -> Void in
            make.left.right.equalTo(self!.bottomLine)
            make.top.equalTo(self!.contentView)
            make.height.equalTo(UICreaterUtils.normalLineWidth)
        }
        return view
    }()
    
    private lazy var bottomLine:UIView = {
        let view:UIView = UIView()
        view.backgroundColor = UICreaterUtils.normalLineColor
        self.contentView.addSubview(view)
        view.snp_makeConstraints { [weak self](make) -> Void in
            make.left.equalTo(self!.contentView).offset(10)
            make.right.equalTo(self!.contentView).offset(-10)
            make.bottom.equalTo(self!.contentView)
            make.height.equalTo(UICreaterUtils.normalLineWidth)
        }
        return view
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UICreaterUtils.createLabel(16,UICreaterUtils.colorBlack,"",true,self.contentView)
        label.snp_makeConstraints { [weak self](make) -> Void in
            make.left.equalTo(self!.iconBack.snp_right).offset(10)
            make.centerY.equalTo(self!.contentView)
        }
        return label
    }()
    
    private lazy var phoneLabel:UILabel = {
        let label = UICreaterUtils.createLabel(14,UICreaterUtils.colorFlat,"",true,self.contentView)
        label.snp_makeConstraints { [weak self](make) -> Void in
            make.left.equalTo(self!.titleLabel.snp_right).offset(5)
//            make.right.equalTo(self!.contentView).offset(-5)
            make.centerY.equalTo(self!.contentView)
        }
        return label
    }()
    
//    private lazy var tagView:RoundTagView = {
//        let roundTag = RoundTagView()
//        self.contentView.addSubview(roundTag)
//        
//        roundTag.snp_makeConstraints(closure: { [weak self](make) -> Void in
//            make.left.equalTo(self!.bottomLine)
//            make.centerY.equalTo(self!.contentView)
//        })
//        return roundTag
//    }()
    
    override func showSubviews() {
        let view:UIView? = self
        if view == nil{
            return
        }
        self.selectionStyle = UITableViewCellSelectionStyle.Blue
        self.backgroundColor = UIColor.whiteColor()
        self.iconView.hidden = false
        self.topLine.hidden = indexPath.row != 0
        initText()
    }

    private func initText(){
        let hvo:HelpInfoVo = data as! HelpInfoVo
        
        titleLabel.text = hvo.name
        titleLabel.sizeToFit()
        
        phoneLabel.text = "Tel:" + hvo.contact
        phoneLabel.sizeToFit()
        
//        tagView.tagText = "\(indexPath.row + 1)"
    }
    
    
    
    
}


