
//
//  MyTabItemRenderer.swift
//  FinanceApplicationTest
//
//  Created by 高扬 on 15/10/17.
//  Copyright (c) 2015年 高扬. All rights reserved.
//

import UIKit

struct TabRendererVo {
    var title:String!
    var iconUrl:String!
}
class MyTabItemRenderer: BaseItemRenderer {
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        if(selected){
            //设置圆角矩形范围
            let toppadding:CGFloat = 2
            let leftpadding:CGFloat = 5
            let pathRect = CGRectMake(leftpadding, toppadding, rect.width - leftpadding * 2, rect.height - toppadding * 2)
            let path = UIBezierPath(roundedRect: pathRect,
                byRoundingCorners: UIRectCorner.AllCorners,
                cornerRadii: CGSize(width: 3.0, height: 3.0))
//            path.addClip()//减去(遮罩)成为圆角矩形
            //        path.lineWidth = arcWidth
            themeColor.colorWithAlphaComponent(0.3).setFill()
//            themeColor.copyWithAlpha(0.3).setFill()
            //        FlatUIColors.alizarinColor(alpha: 0.3).setFill()
            path.fill()
        }
    }
    
    private var labelView:UILabel!
//    private var imageView:UIImageView!
    private func initLabel(){
        if labelView == nil{
            labelView = UILabel()
            labelView.font = UIFont.systemFontOfSize(10)//20号
            labelView.textAlignment = NSTextAlignment.Center
            addSubview(labelView)
            
            labelView.snp_makeConstraints { [weak self](make) -> Void in
                make.centerX.equalTo(self!)
                make.left.equalTo(self!)
                make.right.equalTo(self!)
                make.bottom.equalTo(self!).offset(-2)
            }
        }
        let vo = data as! TabRendererVo
        
        labelView.text = vo.title
        labelView.textColor = themeColor
        //        labelView.sizeToFit()
    }
    
    private var imageContainer:UIView!
    private var tabItem:UIFlatImageTabItem!
    private func initImage(){
        if imageContainer == nil{
            imageContainer = UIView()
//            tempUI.enabled = false
            imageContainer.userInteractionEnabled = false//无法交互
            addSubview(imageContainer)
            
            imageContainer.snp_makeConstraints { [weak self](make) -> Void in
                make.left.equalTo(self!)
                make.right.equalTo(self!)
                make.bottom.equalTo(self!.labelView.snp_top)
                make.top.equalTo(self!).offset(5)
            }
            
            tabItem = UIFlatImageTabItem()
            //        tabItem.backgroundColor = UIColor.blackColor()
            imageContainer.addSubview(tabItem)
            tabItem.sizeType = .FillWidth
            tabItem.normalColor = MyTabItemRenderer.normalColor
            tabItem.selectColor = MyTabItemRenderer.selectColor
            
            tabItem.snp_makeConstraints(closure: { [weak self](make) -> Void in
                make.height.equalTo(20)
                make.left.right.equalTo(self!.imageContainer)
                make.center.equalTo(self!.imageContainer)
            })
//            imageView = UIImageView()
//            tempUI.addSubview(imageView)
//            
//            imageView.snp_makeConstraints { (make) -> Void in
//                make.center.equalTo(tempUI)
//            }
            
        }
        
        let vo = data as! TabRendererVo
        BatchLoaderUtil.loadFile(vo.iconUrl, callBack: { [weak self](image, params) -> Void in
            self!.tabItem.image = image
        })
        self.tabItem.select = selected
    }
    
//    private func showImage(){
//        if(selected){
//            imageView.image = selectImage
//        }else{
//            imageView.image = normalImage
//        }
//    }
    
//    private var normalImage:UIImage!
//    private var selectImage:UIImage!
    
    private static var normalColor:UIColor = FlatUIColors.concreteColor()
    private static var selectColor:UIColor = BestUtils.themeColor///FlatUIColors.belizeHoleColor()//UIColor(red: 232 / 255, green: 50 / 255, blue: 85 / 255, alpha: 1) //FlatUIColors.alizarinColor(alpha: 1)
    
    private var themeColor:UIColor!
    override func layoutSubviews(){
        self.backgroundColor = UIColor.whiteColor()
        if(selected){
            themeColor = MyTabItemRenderer.selectColor
        }else{
            themeColor = MyTabItemRenderer.normalColor
        }
        initLabel()
        initImage()
        setNeedsDisplay()
    }
    
}
