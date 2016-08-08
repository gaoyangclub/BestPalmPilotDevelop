//
//  BestUtils.swift
//  BestPalmPilot
//
//  Created by admin on 16/1/15.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit
import CoreLibrary

public class BestUtils:AnyObject {

    public static let themeColor = UIColor(red: 49/255, green: 93/255, blue: 176/255, alpha: 1)
    //FlatUIColors.dodgerBlueColor()
    
    public static let deputyColor = UIColor(red: 65/255, green: 142/255, blue: 200/255, alpha: 1)//FlatUIColors.belizeHoleColor()//peterRiverColor()
    
    public static let backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    /** 审批同意 */
    public static let AUDIT_APPROVE = "APPROVE"
    /** 审批退回 */
    public static let AUDIT_REJECT = "REJECT"
    
    public static func generateObjByJson(json:JSON,type:NSObject.Type)->NSObject{
        return generateObjByJson(json,typeList: [type])
    }
    
    public static func generateObjByJson(json:JSON,typeList:[NSObject.Type],selectIndex:Int = 0)->NSObject{
        let classType = typeList[selectIndex]
        let obj = classType.init()
//        print(json)
        for (key,value) in json{
            if value.type == .Null{//数据为null
                continue
            }
            if obj.respondsToSelector(Selector(key)){//字段在对象中存在
                if value.type == .Array{
                    var arr:[AnyObject] = []
                    for subJson in value.arrayValue{
                        arr.append(generateObjByJson(subJson,typeList: typeList,selectIndex: selectIndex + 1))
                    }
                    obj.setValue(arr, forKey: key)
                    //                putObjectValue(obj, key: key, value: arr)
                    //                (obj.valueForKey(key)  Array).append(obj)
                }else{
                    //                do{
                    //                    var a:AnyObject? = value.object
                    //                    try obj.validateValue(&a, forKeyPath: key)
                    ////                    obj.validateValue(<#T##ioValue: AutoreleasingUnsafeMutablePointer<AnyObject?>##AutoreleasingUnsafeMutablePointer<AnyObject?>#>, forKey: <#T##String#>)
                    //                }catch{
                    //                    print("字段" + key + "不存在")
                    //                }
                    obj.setValue(value.object, forKey: key)
                    //                putObjectValue(obj, key: key, value: value.object)
                }
            }else{
                print("字段" + key + "不存在")
            }
//            if !(value.object is NSNull){
//                
//            }
        }
        return obj
    }
    
//    private static func putObjectValue(obj:NSObject,key:String,value:AnyObject){
////        print(obj.valueForKey(key)?.classForCoder)
//        if obj.valueForKey(key) is Observable<AnyObject>{
//            obj.setValue(Observable(value), forKey: key)
//        }else{
//            obj.setValue(value, forKey: key)
//        }
//    }
    
//    public static func generateDicByObj(obj:NSObject){
//        for (key,value) in obj {
//            
//        }
//    }
    
    public static func showAlert(title:String = "提示",message:String,oklabel:String = "确定",cancellabel:String = "取消",parentController:UIViewController,useCancel:Bool = true,
        okHandler:((UIAlertAction) -> Void)?){
            let alertController = UIAlertController(title:title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: oklabel, style: UIAlertActionStyle.Default, handler: okHandler)
            alertController.addAction(okAction)
            if useCancel {
                let cancelAction = UIAlertAction(title: cancellabel, style: UIAlertActionStyle.Default, handler: nil)
                alertController.addAction(cancelAction)
            }
            parentController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    public static func createNavigationTitleLabel(parent:UIView,title:String = "")->UILabel{
        let label:UILabel = UICreaterUtils.createLabel(20, themeColor, title, true, parent)//UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(20)//20号 ,weight:2
        
        label.snp_makeConstraints { (make) -> Void in //[weak self]
            make.center.equalTo(parent)
        }
        return label
    }
    
    public static func createNavigationLeftButtonItem(target:AnyObject?,action:Selector)->UIBarButtonItem{
        let buttonItem = UIBarButtonItem(title: "嘿嘿", style: UIBarButtonItemStyle.Done, target: target, action: action)
        let customView = UIArrowView(frame:CGRectMake(0, 0, 10, 22))
        customView.direction = .LEFT
        ////        customView.isClosed = true
        customView.lineColor = themeColor//UIColor.whiteColor()
        customView.lineThinkness = 2
        ////        customView.fillColor = UIColor.blueColor()
        buttonItem.customView = customView
        customView.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchDown)
        return buttonItem
    }
    
    private static var _badgeCount:Int = 0
    public static var badgeCount:Int{
        get{
            return _badgeCount
        }
        set(newValue){
            if newValue < 0 {
                _badgeCount = 0
            }else{
                _badgeCount = newValue
            }
            UIApplication.sharedApplication().applicationIconBadgeNumber = _badgeCount
        }
    }
    
    
    
}
extension String{
//    func getMarks()->String{
//        return "\"" + self + "\""
//    }
    public var marks:String{
        get{
            return "\"" + self + "\""
        }
    }
}
extension NSObject{
    public var jsonString:String{
        get{
            do{
                let nsdata = try NSJSONSerialization.dataWithJSONObject(self.mj_keyValues(), options: NSJSONWritingOptions.PrettyPrinted)
                return NSString(data: nsdata, encoding: NSUTF8StringEncoding) as! String
            }catch{
                
            }
            return ""
        }
    }
}
extension UIControl{
    
    public var enableElement:Bool{
        set(newValue){
            enabled = newValue
            if newValue {
                self.alpha = 1
            }else{
                self.alpha = 0.5
            }
        }
        get{
            return enabled
        }
    }
    
}
