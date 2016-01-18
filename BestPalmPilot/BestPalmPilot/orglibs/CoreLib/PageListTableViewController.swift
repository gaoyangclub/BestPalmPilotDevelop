//
//  PageListTableViewController.swift
//  BestPalmPilot
//
//  Created by admin on 16/1/18.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit

class PageListTableViewController: BaseTableViewController {

    var pageSO:PageListSO!// = self.createPageSO()
    var hasSetUp:Bool = false
    
    override func loadView() {
        super.loadView()
        pageSO = createPageSO()
    }
    
    func createPageSO()->PageListSO{
        return PageListSO()
    }
    
    /** 头部下拉全部刷新 */
    func headerRequest(pageSO:PageListSO,callback:(() -> Void)!){
        
    }
    
    /** 底部上拉刷新 */
    func footerRequest(pageSO:PageListSO,callback:((hasData:Bool) -> Void)!){
        
    }
    
    func setupRefresh(){
        self.hasSetUp = true
        
        self.refreshContaner.addHeaderWithCallback(RefreshHeaderView.header(),callback: { [unowned self] ()-> Void in
            self.pageSO.pageNumber = 0//重新清零
           
            self.headerRequest(self.pageSO){ [unowned self] ()-> Void in//获取数据完毕 刷新界面
                self.tableView?.reloadData()
                self.refreshContaner?.headerReset()
            }
        })
        
        self.refreshContaner.addFooterWithCallback(RefreshFooterView.footer(),callback: { [unowned self] ()-> Void in
            let nowPage = self.pageSO.pageNumber
            self.pageSO.pageNumber += 1//页数+1
            
            self.footerRequest(self.pageSO){ [unowned self] hasData in
                if hasData {
                    self.tableView.reloadData()
                    self.refreshContaner.footerReset()
                }else{
                    self.refreshContaner.footerNodata()
                    self.pageSO.pageNumber = nowPage //页数恢复
                }
            }
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if hasSetUp {
            self.refreshContaner.scrollerView.contentOffset.y = 0 //滚轮位置恢复
        }else{
            self.setupRefresh()
            self.refreshContaner.headerBeginRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
class PageListSO:NSObject{
    
    var objectsPerPage:Int = 20 //每页显示20个
    var pageNumber:Int = 0//当前页码
    var lastUpdateTime:String = ""//年月日 时分秒
    
}
