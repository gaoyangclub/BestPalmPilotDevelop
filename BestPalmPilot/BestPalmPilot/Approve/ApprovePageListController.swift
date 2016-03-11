//
//  ApprovePageListController.swift
//  BestPalmPilot
//
//  Created by admin on 16/1/18.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit

class ApprovePageListController: PageListTableViewController {

    var approveMenuVo:ApproveMenuVo!
    
    override func createPageSO() -> PageListSO {
        return FormListSO()
    }
    
    override func headerRequest(pageSO: PageListSO?, callback: ((hasData: Bool,sorttime:String) -> Void)!) {
        let fso = generateFormListSO(pageSO!)
        BestRemoteFacade.getListFormInfos(fso,groupkey: approveMenuVo.groupkey){[weak self] (json,isSuccess,_) -> Void in
            if self == nil || self!.isDispose  { //self!.isDispose
                print("ApprovePageListController对象已经销毁")
                return
            }
            if isSuccess {
//                print(json)
                var hasData = true
                var sorttime = fso.sorttime //继续用这个时间
                if json!.arrayValue.count > 0{
                    let fromInfoList:[FormInfoVo] = self!.generateFormInfoList(json!.arrayValue)
                    self!.dataSource.removeAllObjects()
                    let formInfoPageSource = self!.getFormInfoPageSource(fromInfoList)
                    for i in 0..<formInfoPageSource.count{
                        self!.dataSource.addObject(formInfoPageSource[i])
                    }
//                    sorttime = fromInfoList.first!.sorttime //更新最新时间
                    sorttime = self!.getLastSortTime(fromInfoList)
//                        fromInfoList.last!.sorttime //更新最新时间
                }else{
                    hasData = false
                }
                callback(hasData:hasData,sorttime:sorttime)
            }else{
                callback(hasData:false,sorttime:"")
            }
        }
    }
    
    private func generateFormListSO(pageSO:PageListSO)->FormListSO{
        let fso = pageSO as! FormListSO
//        fso.code = approveMenuVo.code
        fso.token = UserDefaultCache.getToken()!
        fso.username = UserDefaultCache.getUsercode()!
        return fso
    }
    
    override func footerRequest(pageSO: PageListSO?, callback: ((hasData: Bool,sorttime:String) -> Void)!) {
        let fso = generateFormListSO(pageSO!)
        BestRemoteFacade.getListFormInfos(fso,groupkey: approveMenuVo.groupkey){[weak self] (json,isSuccess,_) -> Void in
            if self == nil || self!.isDispose  { //self!.isDispose
                print("ApprovePageListController对象已经销毁")
                return
            }
            if isSuccess {
                var hasData = true
                var sorttime = fso.sorttime //继续用这个时间
                if json!.arrayValue.isEmpty {
                    hasData = false
                }else{
                    let fromInfoList:[FormInfoVo] = self!.generateFormInfoList(json!.arrayValue)
                    self!.updateFormInfoPageSource(fromInfoList) //直接新增
//                    sorttime = fromInfoList.first!.sorttime //更新最新时间
                    sorttime = self!.getLastSortTime(fromInfoList)
//                        fromInfoList.last!.sorttime //更新最新时间
                }
                callback(hasData:hasData,sorttime:sorttime)
            }else{
                callback(hasData:false,sorttime:"")
            }
        }
    }
    
    //从列表里面取出最新时间
    private func getLastSortTime(fromInfoList:[FormInfoVo])->String{
        let fmt:NSDateFormatter = NSDateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var lastTime = fromInfoList.first!.sorttime
        var lastDate:NSDate? = fmt.dateFromString(lastTime)
        for i in 1..<fromInfoList.count{
            let date2:NSDate? = fmt.dateFromString(fromInfoList[i].sorttime)
            if date2?.timeIntervalSince1970 < lastDate?.timeIntervalSince1970{ //取最老的时间
                lastTime = fromInfoList[i].sorttime
                lastDate = date2
            }
        }
        return lastTime
    }
    
    private func generateFormInfoList(jsonList:[JSON])->[FormInfoVo]{
        var formList:[FormInfoVo] = []
        for json in jsonList{
            let avo = BestUtils.generateObjByJson(json,typeList: [FormInfoVo.self]) as! FormInfoVo
            formList.append(avo)
//            print("sorttime:" + avo.sorttime)
        }
        return formList
    }
    
    private func getFormInfoPageSource(infoList:[FormInfoVo])->NSMutableArray{
        let  svo = SoueceVo(data: []) //添加新的
        for avo in infoList{
            svo.data?.addObject(CellVo(cellHeight: FormInfoPageCell.cellHeight, cellClass: FormInfoPageCell.self,cellData:avo))
        }
        return [svo]
    }
    
    private func updateFormInfoPageSource(infoList:[FormInfoVo]){
        if infoList.count == 0{
            return
        }
        if dataSource.count == 0{
            print("添加数据但是原始数据居长度然是0！！！")
            return
        }
        let svo:SoueceVo? = self.dataSource.lastObject as? SoueceVo
        for avo in infoList{
            svo?.data?.addObject(CellVo(cellHeight: FormInfoPageCell.cellHeight, cellClass: FormInfoPageCell.self,cellData:avo))
        }
    }
    
    private lazy var titleView:UIView = UIView()
    private lazy var titleLabel:UILabel = BestUtils.createNavigationTitleLabel(self.titleView,title:"申请审核")
    
    private lazy var leftItem:UIBarButtonItem = BestUtils.createNavigationLeftButtonItem(self,action: "cancelClick")
    
    private lazy var rightItems:[UIBarButtonItem] = {
        let tabItem1 = UIFlatImageTabItem()
        tabItem1.frame = CGRectMake(0, 0, 30, 24)
        tabItem1.sizeType = .FillWidth
        tabItem1.normalColor = BestUtils.themeColor//UIColor.whiteColor()
        //        tabItem.selectColor = UICreaterUtils.colorRise
        BatchLoaderForSwift.loadFile("magnifie", callBack: { (image) -> Void in
            tabItem1.image = image
        })
        tabItem1.addTarget(self, action: "searchClick", forControlEvents: UIControlEvents.TouchDown)
        let rightItem1 =
        UIBarButtonItem(title: "嘿嘿", style: UIBarButtonItemStyle.Done, target: self, action: "searchClick")
        rightItem1.customView = tabItem1
        
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
        let rightItem2 =
        UIBarButtonItem(title: "嘿嘿", style: UIBarButtonItemStyle.Done, target: self, action: "setupClick")
        rightItem2.customView = imageContainer
        return [rightItem2,rightItem1]
    }()
    
    private func initTitleArea(){
        self.navigationItem.leftBarButtonItem = leftItem
        //        self.navigationItem.rightBarButtonItem = rightItem
        self.navigationItem.rightBarButtonItems = rightItems
        self.navigationItem.titleView = titleView
        
        self.title = "申请审核"
        titleLabel.text = self.title
        
        self.view.backgroundColor = BestUtils.backgroundColor
    }
    
    override func viewDidLoad() {
        contentOffsetRest = false
        
        initTitleArea()
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func cancelClick(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func searchClick(){
        let svc = SearchViewController()
        svc.groupkey = self.approveMenuVo.groupkey
        self.navigationController?.pushViewController(svc, animated: true)
    }
    
    func setupClick(){
        self.drawerController.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: { _ -> Void in
            
        })
    }
    
    func deleteRowsByFormInfoVo(formInfoVo:FormInfoVo){
        for section in 0..<dataSource.count{
            let svo = dataSource[section] as! SoueceVo
            for row in 0..<svo.data!.count{
                let cvo = svo.data![row] as! CellVo
                if (cvo.cellData as! FormInfoVo) == formInfoVo {
                    svo.data?.removeObject(cvo) //数据先移除
                    
                    tableView.beginUpdates()
                    tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: row, inSection: section)], withRowAnimation:                     UITableViewRowAnimation.Bottom)
                    tableView.endUpdates()
                    
                    approveMenuVo.count -= 1
                    BestUtils.badgeCount -= 1 //系统图标数字更新
                    
                    refreshContaner.footerStraight() //底部检查刷新
                    return//删除结束
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false) //反选
        
        let section = indexPath.section
        let source = dataSource[section] as! SoueceVo
        let cell:CellVo = source.data![indexPath.row] as! CellVo
        if cell.cellData is FormInfoVo{
            //点击hot内容跳转
            let fvo = cell.cellData as! FormInfoVo //点击到Fund详细页
            let pageKindController = DetailsPageHomeController()
            pageKindController.groupkey = approveMenuVo.groupkey
            pageKindController.formInfoVo = fvo
            self.navigationController?.pushViewController(pageKindController, animated: true)
        }
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
//    var code:String = ""
    var codeorcreator:String = ""
    var token:String = ""
    var username:String = ""
    
}
public class FormInfoVo:NSObject{
    var id:Float = 0
    var code:String = ""
    var remark:String? = ""//备注
    var showtime:String = ""
    var submitter:String = ""
    var formtype:String = ""
    var sorttime:String = ""
    var lastupdatetime:String = ""
}

class FormInfoPageCell:BaseTableViewCell{
    
    static let cellHeight:CGFloat  = 70
    
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
        let label = UICreaterUtils.createLabel(14,UICreaterUtils.colorBlack,"",true,self.contentView)
        label.snp_makeConstraints { [weak self](make) -> Void in
            make.left.equalTo(self!.tagView.snp_right).offset(10)
            //            make.left.equalTo(50)
            make.bottom.equalTo(self!.contentView.snp_centerY).offset(-4)
        }
        return label
    }()
    
    private lazy var submitterLabel:UILabel = {
        let label = UICreaterUtils.createLabel(12,UICreaterUtils.colorFlat,"",true,self.contentView)
        label.snp_makeConstraints { [weak self](make) -> Void in
            make.right.equalTo(self!.bottomLine)
            make.centerY.equalTo(self!.titleLabel)
        }
        return label
    }()
    
    private lazy var codeLabel:UILabel = {
        let label = UICreaterUtils.createLabel(12,UICreaterUtils.colorBlack,"",true,self.contentView)
        label.snp_makeConstraints { [weak self](make) -> Void in
            make.left.equalTo(self!.titleLabel)
            make.top.equalTo(self!.contentView.snp_centerY).offset(6)
        }
        return label
    }()
    
    private lazy var submitTimeLabel:UILabel = {
        let label = UICreaterUtils.createLabel(12,UICreaterUtils.colorFlat,"",true,self.contentView)
        label.snp_makeConstraints { [weak self](make) -> Void in
            make.right.equalTo(self!.submitterLabel)
            make.centerY.equalTo(self!.codeLabel)
        }
        return label
    }()
    
//    private lazy var arrowView:UIArrowView = {
//        let arrow = UIArrowView(frame:CGRectMake(0, 0, 10, 22))
//        arrow.direction = .RIGHT
//        self.contentView.addSubview(arrow)
//        ////        customView.isClosed = true
//        arrow.lineColor = UICreaterUtils.normalLineColor
//        arrow.lineThinkness = 2
//        return arrow
//    }()
    
    override func showSubviews() {
        let view:UIView? = self
        if view == nil{
            return
        }
        self.selectionStyle = UITableViewCellSelectionStyle.Blue
        self.backgroundColor = UIColor.whiteColor()
        
//        if indexPath.row == 5{
//            print("row5更新")
//        }
        initText()
        
        topLine.hidden = indexPath.row != 0
//            !isFirst
    }
    
    private lazy var tagView:RoundTagView = {
        let roundTag = RoundTagView()
        self.contentView.addSubview(roundTag)
        
        roundTag.snp_makeConstraints(closure: { [weak self](make) -> Void in
            make.left.equalTo(self!.bottomLine)
            make.centerY.equalTo(self!.contentView)
        })
        
        return roundTag
    }()
    
    private func initText(){
        let fvo:FormInfoVo = data as! FormInfoVo
        
//        arrowView.snp_makeConstraints { [weak self](make) -> Void in
//            make.width.equalTo(10)
//            make.height.equalTo(22)
//            make.centerY.equalTo(self.contentView)
//            make.right.equalTo(self.contentView).offset(-10)
//        }
        
//        badgeArea.badgeText = "\(indexPath.row + 1)"
//        badgeArea.hidden = true
        
        titleLabel.text = fvo.formtype
        titleLabel.sizeToFit()
        
        codeLabel.text = fvo.code
        codeLabel.sizeToFit()
        
        submitterLabel.text = fvo.submitter
        submitterLabel.sizeToFit()
        
        submitTimeLabel.text = fvo.showtime
        submitTimeLabel.sizeToFit()
        
        tagView.tagText = "\(indexPath.row + 1)"// + "  section:\(indexPath.section + 1)"
        
    }
    
//    private func createRoundTag(size:CGFloat,tagColor:UIColor,tag:String,parent:UIView)->UIView{
//        let label:UILabel = UICreaterUtils.createLabel(size, tagColor, tag)
//        label.sizeToFit()
//        
//        let subView:UIView = UIView()
//        parent.addSubview(subView)
//        
//        subView.addSubview(label)
//        label.snp_makeConstraints { (make) -> Void in
//            make.center.equalTo(subView)
//        }
//        
//        subView.layer.borderColor = tagColor.CGColor
//        subView.layer.borderWidth = 0.6
//        subView.layer.cornerRadius = 3
//        subView.snp_makeConstraints { (make) -> Void in
//            make.width.equalTo(label).offset(6)
//            make.height.equalTo(label).offset(2)
//        }
//        
//        return subView
//    }
    
}


