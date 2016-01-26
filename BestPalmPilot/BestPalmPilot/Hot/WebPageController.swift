//
//  DetailsWebPageView.swift
//  FinanceApplicationTest
//
//  Created by 高扬 on 15/12/12.
//  Copyright (c) 2015年 高扬. All rights reserved.
//

import UIKit
import WebKit

class WebPageController: UIViewController {

    var linkUrl:String!
    
    private lazy var webView:WKWebView = {
        let view = WKWebView()
        self.view.addSubview(view)
        view.snp_makeConstraints{ (make) -> Void in
            make.left.right.top.bottom.equalTo(self.view)
        }
        return view
    }()
    
    private lazy var titleView:UIView = UIView()
    
    private lazy var titleLabel:UILabel = {
        let label:UILabel = UICreaterUtils.createLabel(20, UIColor.whiteColor(), "", true, self.titleView)
        label.font = UIFont.systemFontOfSize(20)//20号 ,weight:2
        
        self.titleView.addSubview(label)
        label.snp_makeConstraints { [weak self](make) -> Void in //[weak self]
            make.center.equalTo(self!.titleView)
        }
        return label
    }()
    
    private lazy var leftItem:UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(title: "嘿嘿", style: UIBarButtonItemStyle.Done, target: self, action: "cancelClick")
        let customView = UIArrowView(frame:CGRectMake(0, 0, 10, 22))
        customView.direction = .LEFT
        ////        customView.isClosed = true
        customView.lineColor = UIColor.whiteColor()
        customView.lineThinkness = 2
        ////        customView.fillColor = UIColor.blueColor()
        buttonItem.customView = customView
        customView.addTarget(self, action: "cancelClick", forControlEvents: UIControlEvents.TouchDown)
        return buttonItem
    }()
    
    
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
            }
        }
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
