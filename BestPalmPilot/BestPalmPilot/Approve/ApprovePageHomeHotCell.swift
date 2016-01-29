//
//  ApprovePageHomeHotCell.swift
//  BestPalmPilot
//
//  Created by admin on 16/1/15.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit

class ApprovePageHomeHotCell: BaseTableViewCell {
    
    static let cellHeight:CGFloat = 108
    
    private let hotList:[ApproveHotVo] = [
        ApproveHotVo(icon: "fundHot08", title: "帮助人信息", action: "helpHandler:"),
        ApproveHotVo(icon: "fundHot02", title: "审批历史", link: "http://www.baidu.com",enable:false),
        ApproveHotVo(icon: "fundHot09", title: "系统点评", link: "http://www.baidu.com",enable:false),
        ApproveHotVo(icon: "fundHot11", title: "使用说明", link: "http://www.baidu.com",enable:false)
    ]
    
    //    private var iconContainer:UIView!
    override func layoutSubviews(){
        self.contentView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        initCell()
    }
    
    private lazy var bottomLine:UIView = {
        let view:UIView = UIView()
        view.backgroundColor = UICreaterUtils.normalLineColor
        self.addSubview(view)
        return view
    }()
    
    private lazy var topLine:UIView = {
        let view:UIView = UIView()
        view.backgroundColor = UICreaterUtils.normalLineColor
        self.addSubview(view)
        return view
    }()
    
    private func initCell(){
        self.contentView.removeAllSubViews() //先全部移除
        
        topLine.snp_makeConstraints { [weak self](make) -> Void in
            make.left.right.top.equalTo(self!)
            make.height.equalTo(UICreaterUtils.normalLineWidth)
        }
        
        bottomLine.snp_makeConstraints { [weak self](make) -> Void in
            make.left.right.bottom.equalTo(self!)
            make.height.equalTo(UICreaterUtils.normalLineWidth)
        }
        
        var preItem:UIView?
        for i in 0..<hotList.count{
            let avo = hotList[i]
            let area:UIControl = UIControl()
            area.enableElement = avo.enable
            area.tag = i
            if avo.action != nil{
                area.addTarget(self, action: avo.action!, forControlEvents: UIControlEvents.TouchUpInside)
            }else{
                area.addTarget(self, action: "linkHandler:", forControlEvents: UIControlEvents.TouchUpInside)
            }
            self.contentView.addSubview(area)
            area.snp_makeConstraints(closure: { [weak self](make) -> Void in
                make.top.bottom.equalTo(self!.contentView)
                make.width.equalTo(self!.contentView).dividedBy(self!.hotList.count)
                //                make.left.equalTo(self.contentView.snp_width).multipliedBy(Double(i) / Double(hotList.count))
                if preItem != nil{
                    make.left.equalTo(preItem!.snp_right)
                }else{
                    make.left.equalTo(0)
                }
            })
            
            let titleLabel = UICreaterUtils.createLabel(12, UICreaterUtils.colorBlack, hotList[i].title, true, area)
            titleLabel.snp_makeConstraints(closure: { (make) -> Void in //[weak self]
                make.centerX.equalTo(area)
                make.bottom.equalTo(-18)
            })
            
            let imageView = UIImageView()
            imageView.contentMode = UIViewContentMode.ScaleAspectFit //保持比例
            area.addSubview(imageView)
            imageView.snp_makeConstraints(closure: { (make) -> Void in //[weak self]
                make.height.equalTo(46)
                make.centerX.equalTo(area)
                make.top.equalTo(18)
            })
            BatchLoaderUtil.loadFile(hotList[i].icon, callBack: { (image, params) -> Void in
                imageView.image = image
            })
            preItem = area
        }
    }
    
    func helpHandler(area:UIControl){ //帮助人列表
        RootNavigationControl.getInstance().pushViewController(HelpListViewController(), animated: true)
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

