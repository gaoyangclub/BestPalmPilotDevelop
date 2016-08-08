//
//  DetailsWebPageView.swift
//  FinanceApplicationTest
//
//  Created by 高扬 on 15/12/12.
//  Copyright (c) 2015年 高扬. All rights reserved.
//

import UIKit
import WebKit
import CoreLibrary

class WebPageController: UIViewController {

    var linkUrl:String!
    
    private lazy var webView:WKWebView = {
        let view = WKWebView()
        self.view.addSubview(view)
        view.snp_makeConstraints{ [weak self] (make) -> Void in
            make.left.right.top.equalTo(self!.view)
            make.bottom.equalTo(self!.bottomArea.snp_top)
        }
        return view
    }()
    
    private lazy var bottomArea:UIView = {
        let view = UIView()
        self.view.addSubview(view)
        
        view.backgroundColor = UIColor.whiteColor()
        view.snp_makeConstraints(closure: {[weak self] (make) -> Void in
            make.left.right.bottom.equalTo(self!.view)
            make.height.equalTo(45)
            })
        
        let topLine = UIView()
        view.addSubview(topLine)
        topLine.backgroundColor = UICreaterUtils.normalLineColor
        topLine.snp_makeConstraints(closure: {[weak self] (make) -> Void in
            make.left.right.top.equalTo(view)
            make.height.equalTo(UICreaterUtils.normalLineWidth)
            })
        return view
    }()
    
    private lazy var leftButton:GYButton = {
        let btn = GYButton()
        self.view.addSubview(btn)
        btn.snp_makeConstraints(closure: { [weak self](make) -> Void in
            make.width.equalTo(12)
            make.height.equalTo(24)
            make.centerY.equalTo(self!.bottomArea)
            make.left.equalTo(self!.bottomArea).offset(16)
            })
        let leftArrow = UIArrowView()
        leftArrow.userInteractionEnabled = false
        btn.addSubview(leftArrow)
        leftArrow.direction = .LEFT
        leftArrow.lineColor = UICreaterUtils.colorFlat
        leftArrow.lineThinkness = 2
        leftArrow.snp_makeConstraints(closure: { (make) -> Void in
            make.left.right.top.bottom.equalTo(btn)
        })
        return btn
    }()
    
    private lazy var rightButton:GYButton = {
        let btn = GYButton()
        self.bottomArea.addSubview(btn)
        btn.snp_makeConstraints(closure: { [weak self](make) -> Void in
            make.width.equalTo(12)
            make.height.equalTo(24)
            make.centerY.equalTo(self!.bottomArea)
            make.left.equalTo(self!.leftButton.snp_right).offset(40)
            })
        let rightArrow = UIArrowView()
        rightArrow.userInteractionEnabled = false
        btn.addSubview(rightArrow)
        rightArrow.direction = .RIGHT
        rightArrow.lineColor = UICreaterUtils.colorFlat
        rightArrow.lineThinkness = 2
        rightArrow.snp_makeConstraints(closure: { (make) -> Void in
            make.left.right.top.bottom.equalTo(btn)
        })
        return btn
    }()
    
    private lazy var titleView:UIView = UIView()
    private lazy var titleLabel:UILabel = BestUtils.createNavigationTitleLabel(self.titleView)
    
    private lazy var leftItem:UIBarButtonItem = BestUtils.createNavigationLeftButtonItem(self,action: "cancelClick")
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        self.navigationItem.leftBarButtonItem = leftItem
        self.navigationItem.titleView = titleView
        titleLabel.text = self.title
        titleLabel.sizeToFit()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        if hasObserver{
            webView.removeObserver(self, forKeyPath: "estimatedProgress")
            hasObserver = false
        }
        
    }
    
    private var hasObserver = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if linkUrl != nil{
            let url = NSURL(string:linkUrl)
            if url != nil{
                webView.loadRequest(NSURLRequest(URL: url!))
                webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
                hasObserver = true
                
                leftButton.addTarget(self, action: "goBackClick:", forControlEvents: UIControlEvents.TouchUpInside)
                rightButton.addTarget(self, action: "goForwardClick:", forControlEvents: UIControlEvents.TouchUpInside)
            }
        }
    }
    
    func goBackClick(btn:AnyObject){
        webView.goBack()//返回上一页
    }
    
    func goForwardClick(btn:AnyObject){
        webView.goForward()//返回下一页
    }
    
    private lazy var progressView:UIProgressView = {
        let pView = UIProgressView()
        pView.trackTintColor = FlatUIColors.silverColor(1)//UIColor.orangeColor()
        pView.progressTintColor = UIColor.clearColor()
        self.view.addSubview(pView)
        pView.snp_makeConstraints(closure: { (make) -> Void in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(3)
        })
        return pView
    }()
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (keyPath == "estimatedProgress") {
            progressView.hidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            
            leftButton.enabled = webView.canGoBack
            rightButton.enabled = webView.canGoForward
        }
    }
    
    func cancelClick(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
