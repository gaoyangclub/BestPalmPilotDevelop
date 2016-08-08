//
//  DetailsPageInfoController.swift
//  BestPalmPilot
//
//  Created by admin on 16/1/20.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit
import CoreLibrary

class DetailsPageInfoController: PageListTableViewController {

    var formKey:String!//上层获取数据关键字
    weak var delegate:DetailsPageDelegate?
    
    
    override func headerRequest(pageSO: PageListSO?, callback: ((hasData: Bool,sorttime:String) -> Void)!) {
        delegate?.getFormDetails?(hasFirstRefreshed, formKey: formKey, callback: { [weak self](dataList:[FormDetailVo]) -> Void in
            if self == nil || self!.isDispose  {
                print("DetailsPageInfoController对象已经销毁")
                return
            }
            //遍历显示
            var hasData = true
            if dataList.count > 0{
                self!.dataSource.removeAllObjects()
                let formDetailPageSource = self!.getFormDetailPageSource(dataList)
                for item in formDetailPageSource{
                    self!.dataSource.addObject(item)
                }
            }else{
                hasData = false
            }
            callback(hasData:hasData,sorttime:"")
        })
    }
    
    func getFormDetailPageSource(dataList:[FormDetailVo])->NSMutableArray{
        let sourceList:NSMutableArray = []
        for dvo in dataList{
            let svo = SourceVo(data: [], headerHeight: FormDetailHeader.headerHeight, headerClass: FormDetailHeader.self, headerData: dvo.title)//添加新的
            sourceList.addObject(svo)
            
            for cvo in dvo.content {
                svo.data?.addObject(CellVo(cellHeight: FormDetailCell.cellHeight, cellClass: FormDetailCell.self,cellData:cvo))
            }
        }
        return sourceList
    }
    
    override func viewWillAppear(animated: Bool) {
        showFooter = false
        super.viewWillAppear(animated)
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
class FormDetailHeader:BaseItemRenderer{
    
    static var headerHeight:CGFloat = 36
    
    override func layoutSubviews() {
        initSquare()
        initLabel()
        self.backgroundColor = UIColor.whiteColor()
        
        topLine.snp_makeConstraints { [weak self](make) -> Void in
            make.left.equalTo(self!).offset(FormDetailCell.padding)
            make.right.equalTo(self!).offset(-FormDetailCell.padding)
            make.top.equalTo(self!)
            make.height.equalTo(UICreaterUtils.normalLineWidth)
        }
        
        bottomLine.snp_makeConstraints { [weak self](make) -> Void in
            make.left.equalTo(self!).offset(FormDetailCell.padding)
            make.right.equalTo(self!).offset(-FormDetailCell.padding)
            make.bottom.equalTo(self!)
            make.height.equalTo(UICreaterUtils.normalLineWidth)
        }
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
    
    private var square:UIView!
    private func initSquare(){
        if square == nil{
            square = UIView()
            addSubview(square)
            square.backgroundColor = BestUtils.deputyColor
            square.snp_makeConstraints(closure: { [weak self](make) -> Void in
                make.left.equalTo(self!.topLine).offset(10 - 5)
                make.centerY.equalTo(self!)
                make.width.equalTo(5)
                make.height.equalTo(18)
            })
        }
    }
    
    private var title:UILabel!
    private func initLabel(){
        if(title == nil){
            title = UILabel()
            title.font = UIFont.systemFontOfSize(14)
            title.textColor = UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 1)
            addSubview(title)
            title.snp_makeConstraints(closure: { [weak self](make) -> Void in
                make.left.equalTo(self!.square.snp_right).offset(10)
                make.centerY.equalTo(self!)
            })
        }
        let info:String = data as! String
        title.text = info
        title.sizeToFit()
    }
    
}
class FormDetailCell:BaseTableViewCell{
    
    static var cellHeight:CGFloat = 32

    private lazy var titleLabel:UILabel = {
        let label = UICreaterUtils.createLabel(14, UICreaterUtils.colorFlat, "测试标题", true, self.contentView)
//        label.backgroundColor = UIColor.orangeColor()
        label.snp_makeConstraints{ [weak self](make) -> Void in
            make.width.greaterThanOrEqualTo(100)
            make.left.equalTo(self!.contentView).offset(FormDetailCell.padding + 10)
            make.centerY.equalTo(self!.contentView)
        }
        return label
    }()
    
    private lazy var infoLabel:UILabel = {
        let label = UICreaterUtils.createLabel(12, UICreaterUtils.colorFlat, "测试标题", true, self.contentView)
//        label.snp_makeConstraints{ [weak self](make) -> Void in
//            make.left.equalTo(self!.titleLabel.snp_right).offset(10)
//            make.right.equalTo(self!.contentView).offset(-FormDetailCell.padding-10)
//            make.centerY.equalTo(self!.contentView)
//        }
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.Left
        return label
    }()
    
    override func showSubviews() {
        self.backgroundColor = UIColor.whiteColor()
        initLabel()
    }
    
    override var cellVo:CellVo?{
        didSet{
            initLabel() //预先测量
            setNeedsLayout()
        }
    }
    
    private static let padding:CGFloat = 5
    private func initLabel(){
        
        let cvo = data as! FormContentVo
        titleLabel.text = cvo.fieldname + ":"
        titleLabel.sizeToFit()
        
        infoLabel.text = cvo.fieldcontent
//        infoLabel.adjustsFontSizeToFitWidth = true
//        infoLabel.backgroundColor = UIColor.orangeColor()
        
        let infoLeft = titleLabel.frame.origin.x + titleLabel.frame.width < 90 ? 90 :titleLabel.frame.width
        let infoWidth = self.frame.width - infoLeft - FormDetailCell.padding - 10
        infoLabel.frame = CGRectMake(infoLeft, 0, infoWidth, 0)
        infoLabel.sizeToFit()
        
        if infoLabel.frame.height > FormDetailCell.cellHeight{
//            print("超过:\(infoLabel.frame.height - FormDetailCell.cellHeight)")
            cellVo?.cellHeight = infoLabel.frame.height + 5
//            tableView?.deselectRowAtIndexPath(self.indexPath, animated: false)
//            tableView!.reloadRowsAtIndexPaths([self.indexPath], withRowAnimation: UITableViewRowAnimation.None)
//            tableView?.beginUpdates()
//            tableView?.endUpdates()
        }else{
            infoLabel.center.y = self.frame.height / 2
        }
//        print(infoLabel.frame.height)
    }
    

}





