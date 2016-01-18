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
        ApproveHotVo(icon: "fundHot02", title: "使用说明1", link: "http://www.qq.com"),
        ApproveHotVo(icon: "fundHot08", title: "使用说明2", link: "http://www.qq.com"),
        ApproveHotVo(icon: "fundHot09", title: "使用说明3", link: "http://www.qq.com"),
        ApproveHotVo(icon: "fundHot11", title: "使用说明4", link: "http://www.qq.com")
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
    
    private func initCell(){
        self.contentView.removeAllSubViews() //先全部移除
        
        bottomLine.snp_makeConstraints { [unowned self](make) -> Void in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(UICreaterUtils.normalLineWidth)
        }
        
        var preItem:UIView?
        for i in 0..<hotList.count{
            let area:UIControl = UIControl()
            area.tag = i
            area.addTarget(self, action: "hotClickHandler:", forControlEvents: UIControlEvents.TouchUpInside)
            self.contentView.addSubview(area)
            area.snp_makeConstraints(closure: { [unowned self](make) -> Void in
                make.top.bottom.equalTo(self.contentView)
                make.width.equalTo(self.contentView).dividedBy(self.hotList.count)
                //                make.left.equalTo(self.contentView.snp_width).multipliedBy(Double(i) / Double(hotList.count))
                if preItem != nil{
                    make.left.equalTo(preItem!.snp_right)
                }else{
                    make.left.equalTo(0)
                }
            })
            
            let titleLabel = UICreaterUtils.createLabel(12, UICreaterUtils.colorBlack, hotList[i].title, true, area)
            titleLabel.snp_makeConstraints(closure: { (make) -> Void in //[unowned self]
                make.centerX.equalTo(area)
                make.bottom.equalTo(-18)
            })
            
            let imageView = UIImageView()
            imageView.contentMode = UIViewContentMode.ScaleAspectFit //保持比例
            area.addSubview(imageView)
            imageView.snp_makeConstraints(closure: { (make) -> Void in //[unowned self]
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
    
    func hotClickHandler(area:UIControl){
        print("热键说明按钮点击")
        //        let link = hotList[area.tag].link
        //        //        println("链接:" + link)
        //        let webController = DetailsWebPageController()
        //        webController.linkUrl = link//"https://m.baidu.com/from=844b/s?word=" + noticeVo.title
        //
        //        let nc = NSNotification(name: "FundHome:pushView", object: webController)
        //        NSNotificationCenter.defaultCenter().postNotification(nc)
    }
    
    
}

