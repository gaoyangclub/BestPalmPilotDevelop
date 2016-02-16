//
//  RoundTagView.swift
//  BestPalmPilot
//
//  Created by admin on 16/1/19.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit

class RoundTagView:UIView{
    
    var tagSize:CGFloat = 10{
        didSet{
            setNeedsLayout()
        }
    }
    var tagColor:UIColor = UIColor.grayColor(){
        didSet{
            setNeedsLayout()
        }
    }
    
    var tagText:String = ""{
        didSet{
            setNeedsLayout()
        }
    }
    
    var backColor:UIColor = UIColor.blackColor(){
        didSet{
            setNeedsLayout()
        }
    }
    
    var showBorder:Bool = true{
        didSet{
            setNeedsLayout()
        }
    }
    
    var borderWidth:CGFloat = 0.6{
        didSet{
            setNeedsLayout()
        }
    }
    
    var cornerRadius:CGFloat = 3{
        didSet{
            setNeedsLayout()
        }
    }
    
    var showBack:Bool = false{
        didSet{
            setNeedsLayout()
        }
    }
    
    //    private lazy var tagLabel:UILabel = {
    //       let labal = UICreaterUtils.createLabel(10, UIColor.grayColor(), "")
    //        return labal
    //    }()
    private var tagLabel:UILabel!
    //    private var subView:UIView!
    
    override func layoutSubviews() {
        initView()
    }
    
    var minTagWidth:CGFloat = 20{
        didSet{
            setNeedsLayout()
        }
    }
    var minTagHeight:CGFloat = 10{
        didSet{
            setNeedsLayout()
        }
    }
    
    private func initView(){
        if tagLabel == nil{
            tagLabel = UICreaterUtils.createLabel(tagSize, tagColor, "",true,self)
            tagLabel.textAlignment = NSTextAlignment.Center
            //            subView = UIView()
            //            addSubview(subView)
            
            tagLabel.snp_makeConstraints { [weak self](make) -> Void in
                make.center.equalTo(self!)
            }
            
            if showBorder {
                self.layer.borderColor = tagColor.CGColor
                self.layer.borderWidth = borderWidth
            }else{
                self.layer.borderWidth = 0
            }
            if showBack{
                self.backgroundColor = self.backColor
            }else{
                self.backgroundColor = UIColor.clearColor()
            }
            self.layer.cornerRadius = cornerRadius
            self.snp_makeConstraints { [weak self](make) -> Void in
                make.width.greaterThanOrEqualTo(self!.minTagWidth)
                make.width.equalTo(self!.tagLabel).offset(6)
                make.height.greaterThanOrEqualTo(self!.minTagHeight)
                make.height.equalTo(self!.tagLabel).offset(2)
            }
        }
        tagLabel.text = tagText
        tagLabel.font = UIFont.systemFontOfSize(tagSize)
        tagLabel.textColor = tagColor
        tagLabel.sizeToFit()
    }
}
