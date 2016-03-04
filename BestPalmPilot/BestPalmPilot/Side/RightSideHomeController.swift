//
//  RightSideHomeController.swift
//  BestPalmPilot
//
//  Created by admin on 16/3/3.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit

class RightSideHomeController: PageListTableViewController {

    private let sideInfoList:[SideInfoVo] = [
        SideInfoVo(title:"版本信息 \n" + BestRemoteFacade.appVersion),
        SideInfoVo(title:"关于我们")//,action:"aboutClick"
    ]
    
    //创建纯内容列表 无拖动刷新功能
    override func pureTable() -> Bool {
        let svo = SoueceVo(data: [])
        for avo in sideInfoList{
            svo.data?.addObject(CellVo(cellHeight: SideHomeInfoCell.cellHeight, cellClass: SideHomeInfoCell.self,cellData:avo))
            if avo.action != nil{
                msgProxy.addTarget(self, action: Selector(avo.action!), forControlEvents: UIControlEvents.TouchUpInside)
            }
        }
        self.dataSource.addObject(svo)
        self.tableView?.scrollEnabled = false//无法滑动
        return true
    }
    
    private lazy var msgProxy:UIControl = UIControl()
    
    //重写refreshContaner布局
    override func refreshContanerMake(make:ConstraintMaker)-> Void{
        make.left.right.bottom.equalTo(self.view)
        make.top.equalTo(self.view).offset(20)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        let source = dataSource[section] as! SoueceVo
        let cell:CellVo = source.data![indexPath.row] as! CellVo
        if cell.cellData is SideInfoVo{
            //点击hot内容跳转
            let svo = cell.cellData as! SideInfoVo //点击到Fund详细页
            if svo.action != nil{
                tableView.deselectRowAtIndexPath(indexPath, animated: false)//反选
                msgProxy.sendAction(Selector(svo.action!), to: self, forEvent: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = BestUtils.backgroundColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func aboutClick(){
        print("点击关于我们")
    }


}
private class SideInfoVo:NSObject{
    
    init(icon:String? = nil,title:String,action:String? = nil) {
        self.icon = icon;
        self.title = title;
        self.action = action;
    }
    
    var icon:String? = ""
    var title:String = ""
    var action:String? = ""
}
private class SideHomeInfoCell: BaseTableViewCell {
    static let cellHeight:CGFloat = 48
    
    private lazy var topLine:UIView = {
        let view:UIView = UIView()
        view.backgroundColor = UICreaterUtils.normalLineColor
        self.contentView.addSubview(view)
        view.snp_makeConstraints { [weak self](make) -> Void in
            make.top.equalTo(self!.contentView)
            make.left.right.equalTo(self!.bottomLine)
            make.height.equalTo(UICreaterUtils.normalLineWidth)
        }
        return view
    }()
    
    private lazy var bottomLine:UIView = {
        let view:UIView = UIView()
        view.backgroundColor = UICreaterUtils.normalLineColor
        self.contentView.addSubview(view)
        view.snp_makeConstraints { [weak self](make) -> Void in
            make.left.right.bottom.equalTo(self!.contentView)
            make.height.equalTo(UICreaterUtils.normalLineWidth)
        }
        return view
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UICreaterUtils.createLabel(18, UICreaterUtils.colorFlat, "", true, self.contentView)
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.Left
        label.snp_makeConstraints { [weak self](make) -> Void in
            make.left.equalTo(self!.contentView).offset(10)
            make.centerY.equalTo(self!.contentView)
            make.right.equalTo(self!.arrowView).offset(-10)
        }
        return label
    }()
    
    private lazy var arrowView:UIArrowView = {
        let arrow = UIArrowView(frame:CGRectMake(0, 0, 10, 22))
        arrow.direction = .RIGHT
        self.contentView.addSubview(arrow)
        ////        customView.isClosed = true
        arrow.lineColor = UICreaterUtils.normalLineColor
        arrow.lineThinkness = 2
        arrow.snp_makeConstraints { [weak self](make) -> Void in
            make.width.equalTo(10)
            make.height.equalTo(22)
            make.centerY.equalTo(self!.contentView)
            make.right.equalTo(self!.contentView).offset(-16)
        }
        return arrow
    }()
    
    private override func showSubviews() {
        self.backgroundColor = UIColor.whiteColor()
        
        topLine.hidden = indexPath.row != 0
        initText()
    }
    
    private func initText(){
        let svo:SideInfoVo = data as! SideInfoVo
        
        titleLabel.text = svo.title;
        titleLabel.sizeToFit()
        
        self.selectionStyle = svo.action == nil ? UITableViewCellSelectionStyle.None : UITableViewCellSelectionStyle.Gray
        arrowView.hidden = svo.action == nil
    }
    
    
    
}


