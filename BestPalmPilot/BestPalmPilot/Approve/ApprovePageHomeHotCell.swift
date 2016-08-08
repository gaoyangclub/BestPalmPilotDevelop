//
//  ApprovePageHomeHotCell.swift
//  BestPalmPilot
//
//  Created by admin on 16/1/15.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit
import CoreLibrary

class ApprovePageHomeHotCell: BaseTableViewCell {
    
    static let cellHeight:CGFloat = 80
    
    private let hotList:[ApproveHotVo] = [
        ApproveHotVo(icon: "message", title: "帮助人信息", action: "helpHandler:"),
        ApproveHotVo(icon: "comment", title: "系统点评", action: "commentHandler:")
//        ApproveHotVo(icon: "history", title: "审批历史", link: "http://www.baidu.com",enable:false),
//        ApproveHotVo(icon: "instruction", title: "使用说明", link: "http://www.baidu.com",enable:false)
    ]
    
    //    private var iconContainer:UIView!
    
    override func showSubviews() {
        self.contentView.backgroundColor = UIColor(red: 237/255, green: 243/255, blue: 255/255, alpha: 1)
        initCell()
    }
//    
//    override func layoutSubviews(){
//        
//    }
    
    private lazy var bottomLine:UIView = {
        let view:UIView = UIView()
        view.backgroundColor = UICreaterUtils.normalLineColor
        self.contentView.addSubview(view)
        return view
    }()
    
    private lazy var topLine:UIView = {
        let view:UIView = UIView()
        view.backgroundColor = UICreaterUtils.normalLineColor
        self.contentView.addSubview(view)
        return view
    }()
    
    private lazy var btnContainer:UIView = {
        let view:UIView = UIView()
        self.contentView.addSubview(view)
        return view
    }()
    
    private func initCell(){
        
        btnContainer.snp_makeConstraints { [weak self](make) -> Void in
            make.left.right.top.equalTo(self!.contentView)
        }
        
        topLine.snp_makeConstraints { [weak self](make) -> Void in
            make.left.right.top.equalTo(self!.contentView)
            make.height.equalTo(UICreaterUtils.normalLineWidth)
        }
        
        bottomLine.snp_makeConstraints { [weak self](make) -> Void in
            make.left.right.bottom.equalTo(self!.contentView)
            make.height.equalTo(UICreaterUtils.normalLineWidth)
        }
        
//        let subW = Float(self.contentView.frame.width / CGFloat(self.hotList.count))
        
        self.btnContainer.removeAllSubViews() //先全部移除
//        var preItem:UIView?
        let subViewList:NSMutableArray = []
        for i in 0..<hotList.count{
            let avo = hotList[i]
            let area:GYButton = GYButton()
            area.enabled = avo.enable
            area.tag = i
            if avo.action != nil{
                area.addTarget(self, action: avo.action!, forControlEvents: UIControlEvents.TouchUpInside)
            }else{
                area.addTarget(self, action: "linkHandler:", forControlEvents: UIControlEvents.TouchUpInside)
            }
            self.btnContainer.addSubview(area)
//            area.snp_makeConstraints(closure: { [weak self](make) -> Void in
//                make.top.bottom.equalTo(self!.contentView)
//                make.width.equalTo(self!.contentView).dividedBy(self!.hotList.count)
////                make.width.equalTo(subW)
//                //                make.left.equalTo(self.contentView.snp_width).multipliedBy(Double(i) / Double(hotList.count))
//                if preItem != nil{
//                    make.left.equalTo(preItem!.snp_right)
//                }else{
//                    make.left.equalTo(0)
//                }
//            })
            
            let titleLabel = UICreaterUtils.createLabel(12, UICreaterUtils.colorBlack, hotList[i].title, true, area)
            titleLabel.snp_makeConstraints(closure: { (make) -> Void in //[weak self]
                make.centerX.equalTo(area)
                make.bottom.equalTo(-16)
            })
            
            let imageView = UIImageView()
            imageView.contentMode = UIViewContentMode.ScaleAspectFit //保持比例
            area.addSubview(imageView)
            imageView.snp_makeConstraints(closure: { (make) -> Void in //[weak self]
                make.height.equalTo(40)
//                make.left.right.equalTo(area)
                make.centerX.equalTo(area)
                make.top.equalTo(10)
            })
            BatchLoaderForSwift.loadFile(hotList[i].icon, callBack: { (image) -> Void in
                imageView.image = image
            })
            
            area.sd_layout().heightRatioToView(self.contentView,1)
            
            subViewList.addObject(area)
//            preItem = area
        }
        btnContainer.setupAutoWidthFlowItems(subViewList as [AnyObject],withPerRowItemsCount:subViewList.count,verticalMargin:0,horizontalMargin:0);
        
    }
    
    func helpHandler(area:UIControl){ //帮助人列表
        RootNavigationControl.getInstance().pushViewController(HelpListViewController(), animated: true)
    }
    
    func commentHandler(area:UIControl){ //系统点评
        RootNavigationControl.getInstance().pushViewController(CommentPageController(), animated: true)
    }
    
    func linkHandler(area:UIControl){ //链接某个网址
//        print("热键网址点击")
        let link = hotList[area.tag].link
        //        //        println("链接:" + link)
        let webController = WebPageController()
        webController.linkUrl = link//"https://m.baidu.com/from=844b/s?word=" + noticeVo.title
        webController.title = hotList[area.tag].title
        
        RootNavigationControl.getInstance().pushViewController(webController, animated: true)
    }
    
}
private class ApproveHotVo{
    init(icon:String,title:String,link:String? = nil,action:Selector? = nil,enable:Bool = true){
        self.icon = icon
        self.title = title
        self.link = link
        self.action = action
        self.enable = enable
    }
    var icon:String!
    var title:String!
    var link:String?
    var action:Selector?
    var enable:Bool = true
}

