//
//  BestUtils.swift
//  BestPalmPilot
//
//  Created by admin on 16/1/15.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit

public class BestUtils:AnyObject {

    public static let themeColor = FlatUIColors.dodgerBlueColor()//UIColor(red: 81/255, green: 121/255, blue: 178/255, alpha: 1)
    public static let deputyColor = FlatUIColors.peterRiverColor()
    
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
            if value.type == .Array{
                var arr:[AnyObject] = []
                for subJson in value.arrayValue{
                    arr.append(generateObjByJson(subJson,typeList: typeList,selectIndex: selectIndex + 1))
                }
                obj.setValue(arr, forKey: key)
//                (obj.valueForKey(key)  Array).append(obj)
            }else{
                obj.setValue(value.object, forKey: key)
            }
//            if !(value.object is NSNull){
//                
//            }
        }
        return obj
    }
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
    func getMarks()->String{
        return "\"" + self + "\""
    }
}
extension NSObject{
    func getJsonString()->String{
        do{
            let nsdata = try NSJSONSerialization.dataWithJSONObject(self.mj_keyValues(), options: NSJSONWritingOptions.PrettyPrinted)
            return NSString(data: nsdata, encoding: NSUTF8StringEncoding) as! String
        }catch{
            
        }
        return ""
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
