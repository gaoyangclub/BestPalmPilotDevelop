//
//  RefreshFooterView.swift
//  PullRefreshScrollerTest
//
//  Created by 高扬 on 15/9/4.
//  Copyright (c) 2015年 高扬. All rights reserved.
//

import UIKit

class RefreshFooterView: RefreshBaseView {

//    private var viewHeight:CGFloat = 0
    
    class func footer()->RefreshFooterView{
        let footer:RefreshFooterView  = RefreshFooterView()
        return footer
    }
    
    override func willMoveToSuperview(newSuperview: UIView!) {
        if isDispose {
            return
        }
        super.willMoveToSuperview(newSuperview)
        if(newSuperview != nil){
            self.frame = CGRectMake(0.0, 0.0, newSuperview!.frame.width, CGFloat(RefreshFooterHeight))
            scrollView.contentInset.bottom = CGFloat(RefreshFooterHeight)
        }
//        try willMoveToSuperview(self)
    }
    
    private var isDispose = false
    deinit{
        isDispose = true
        print("RefreshFooterView销毁")
    }
    
    override var State:RefreshState {
        willSet {
            if  State == newValue{
                return;
            }
            oldState = State
            showArrowState(newValue)
        }
        didSet{
            switch State{
            case RefreshState.Normal:
//                if oldState == RefreshState.Refreshing{
//                    let delayInSeconds:Int64 =  100000000  * 1
//                    var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
//                    dispatch_after(popTime, dispatch_get_main_queue(), {
//                        var addHeight = self.scrollView.contentOffset.y + self.scrollView.frame.height / 8
//                        UIView.animateWithDuration(RefreshSlowAnimationDuration * 2, animations: {
//                            self.scrollView.contentOffset.y = addHeight
//                            }, completion:{ _ in
//                                self.scrollView?.userInteractionEnabled = true
//                        });
//                    })
//                }
                self.statusLabel.text = "";
                self.scrollView?.userInteractionEnabled = true
                self.scrollView?.contentInset.bottom = CGFloat(RefreshFooterHeight);
                break
            case RefreshState.Nodata:
                self.statusLabel.text = RefreshFooterNodata as String;
//                self.scrollView?.userInteractionEnabled = true
                UIView.animateWithDuration(RefreshSlowAnimationDuration, animations: {
                     self.scrollView.contentInset.bottom = CGFloat(RefreshFooterHeight);
                    },completion:{ _ in
                                                        self.scrollView?.userInteractionEnabled = true
                    })
                break;
//            case RefreshState.Pulling:
//                self.statusLabel.text = RefreshFooterReleaseToRefresh as String
//                UIView.animateWithDuration(RefreshSlowAnimationDuration, animations: {
//                    self.arrowImage.transform = CGAffineTransformIdentity
//                })
//                break
            case RefreshState.Refreshing:
                self.statusLabel.text = RefreshFooterRefreshing as String;
                self.scrollView?.userInteractionEnabled = false
                let dirtY:CGFloat = self.scrollView!.contentOffset.y - self.scrollView!.contentSize.height + self.scrollView!.frame.height
//                println(dirtY)
                scrollView.contentInset.bottom = dirtY + CGFloat(RefreshFooterHeight)
                break
            default:
                break
                
            }
        }
    }
    

    override func showSubView(){
        //状态标签
        statusLabel = UILabel()
//        statusLabel.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        statusLabel.font = UIFont.boldSystemFontOfSize(13)
        statusLabel.textColor = RefreshLabelTextColor
        statusLabel.backgroundColor =  UIColor.clearColor()
        statusLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(statusLabel)
        //箭头图片
//        arrowImage = UIImageView(image: UIImage(named: "arrow.png"))
////        arrowImage.autoresizingMask = UIViewAutoresizing.FlexibleWidth
//        self.addSubview(arrowImage)
        //状态标签
        activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
//        activityView.bounds = self.arrowImage.bounds
//        activityView.autoresizingMask = self.arrowImage.autoresizingMask
        self.addSubview(activityView)
        
        statusLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
        }
        
        activityView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.statusLabel.snp_left).offset(-20)
            make.centerY.equalTo(self)
        }
        
        //自己的属性
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.backgroundColor = UIColor.clearColor()
        
        self.State = RefreshState.Normal;
    }
    
    //重写调整frame
    override func adjustFrameWithContentSize(){
        let contentHeight:CGFloat = self.scrollView.contentSize.height
//        var scrollHeight:CGFloat = self.scrollView.frame.size.height
        var rect:CGRect = self.frame;
        rect.origin.y = contentHeight// contentHeight > scrollHeight ? contentHeight : scrollHeight
        self.frame = rect;
    }
    
    override func adjustStateWithContentOffset()
    {
        let currentOffsetY:CGFloat  = self.scrollView.contentOffset.y + self.scrollView.frame.height
        let happenOffsetY:CGFloat = self.scrollView.contentSize.height + self.frame.height
        if currentOffsetY <= happenOffsetY {
            return
        }else if self.scrollView.dragging {
            self.State = RefreshState.Refreshing; //直接开始刷新
        }
    }


}
