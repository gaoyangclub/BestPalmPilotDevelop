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
