//
//  BestRemoteFacade.swift
//  AlamofireTest
//
//  Created by admin on 16/1/12.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit
import Alamofire
import CoreLibrary

typealias ResponseCompletionHandler = (json:JSON?,isSuccess:Bool,error:NSError?)->Void

public class BestRemoteFacade: AnyObject {
    
    public static var isDebug:Bool{
        get{
            let bundleIdentifier = getBundleValue("CFBundleVersion")
            if bundleIdentifier != nil{
                return bundleIdentifier != "1" //测试模式
            }
            return true
        }
    }
    
    private static let restletUrl = isDebug ?
        "http://dianping-test.800best.com/rest/dianping/saveComment" : //点评专用测试地址
        "http://dianping.800best.com/rest/dianping/saveComment" //点评专用生产地址
    
    //    private static let remoteUrl = "http://10.45.10.198:8282/gateway/rest/api/com.best.oasis.husky.ws.mobile.MobileWebService/"
    private static let remoteUrl = isDebug ?
        "http://edi-test.appl.800best.com:1502/gateway/rest/api/com.best.oasis.husky.ws.mobile.MobileWebService/" :
        "http://app-gw.ns.800best.com/gateway/rest/api/com.best.oasis.husky.ws.mobile.MobileWebService/"
    
    private static let headers:Dictionary<String,String> = isDebug ?
        ["X-Route-User":"TEST","X-Route-Token":"TEST"] : //["X-Route-User":"TEST","X-Route-Token":"TEST"]
        ["X-Route-User":"IAPP2","X-Route-Token":"IAPPToken2"] //xingng接口的生产环境配置，X-Route-User：IAPP，X-Route-Token：IAPPToken
    
    private static let appUrl = "http://itunes.apple.com/"
    private static let appId = "1"//"776882837"//从Appstore更新的应用id
    
    private static let appType = "IOS"//
    
    public static var appName:String{
        get{
            return getBundleValue("CFBundleName") ?? "审批管家"
        }
    }
    
    public static var appVersion:String{
        get{
            return getBundleValue("CFBundleShortVersionString") ?? "0.0"
        }
    }
    
    private static func getBundleValue(key:String)->String?{
        let infoDic:NSDictionary? = NSBundle.mainBundle().infoDictionary
        if infoDic != nil && infoDic?.valueForKey(key) is String{
            return infoDic?.valueForKey(key) as? String
        }
        return nil
    }
    
//    private String userId;//点评人的识别码（必填）
//    private String userAttr1;//点评人的三个额外属性（选填）
//    private String userAttr2;
//    private String userAttr3;
//    private String app;//系统名（必填）
//    private String component;//功能模块/组件（选填）
//    private String page;//具体页面（必填）
//    private Integer score;//评价分值（必填）, 分数大于0分，则点评前台显示为好评，小于0分，则显示差评，等于0分，则显示为留言
//    private String detail;//具体的评价描述（好评选填，差评必填）
//    private Date submitTime;//定评时间（必填） 传递时的日期格式为YYYY-MM-DD HH:MI:SS
    
    //提交点评
    static func submitComment(userCode:String,score:Int,component:String,pageTitle:String,detail:String,callBack:ResponseCompletionHandler?){
        let date:NSDate = NSDate()
        let fmt:NSDateFormatter = NSDateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateString = fmt.stringFromDate(date)
        
//        print(component)
//        print(pageTitle)
////        print(phone)
//        print(dateString)
//        print(detail)
        
        let cvo = CommentVo()
        cvo.userId = userCode
        cvo.app = appName
        cvo.score = score
        cvo.component = component
        cvo.page = pageTitle
        cvo.detail = detail
//        cvo.userAttr1 = phone
        cvo.submitTime = dateString
        
        request(restletUrl,parameters:["json":cvo.jsonString],headers:nil,callBack:callBack)
        //["userId":userCode.marks,"app":appName.marks,"component":component.marks,"page":pageTitle.marks,"score":score,"detail":detail.marks,"userAttr1":phone.marks,"submitTime":dateString.marks]
    }
    
    static var appVersionVo:AppVersionVo?
    static func getLastVersion(callBack:(appVersionVo:AppVersionVo)->Void){
        //device
        request(remoteUrl + "getUpdateInfo",parameters:["appType":appType.marks]){ (json, isSuccess, error) -> Void in
            if isSuccess {
                BestRemoteFacade.appVersionVo = BestUtils.generateObjByJson(json!, type: AppVersionVo.self) as? AppVersionVo
                callBack(appVersionVo:BestRemoteFacade.appVersionVo!)
            }
        }
//      getHelpInfo(callBack)
    }
    
    static func getAppStoreVersion(callBack:ResponseCompletionHandler?){
        request(appUrl + "lookup",parameters:["id":appId],headers:nil,callBack:callBack)
    }
    
    static func login(username:String,password:String,appid:String,mobileInfo:String,callBack:ResponseCompletionHandler?){
        request(remoteUrl + "login",parameters:["username":username.marks,"password":password.marks,"appid":appid.marks,"mobileInfo":mobileInfo.marks],callBack:callBack)
    }
    
    static func getApproveMenu(username:String,callBack:ResponseCompletionHandler?){
        request(remoteUrl + "getAppMenu",parameters:["username":username.marks],callBack:callBack)
    }
    
    static func getListFormInfos(so:FormListSO,groupkey:String,callBack:ResponseCompletionHandler?){
        let jsonString = so.jsonString
//        print(jsonString)
        request(remoteUrl + "getListFormInfos",parameters:["so":jsonString,"groupkey":groupkey.marks],
            callBack:callBack)
    }
    
    static func getFormDetailsVo(code:String,groupkey:String,callBack:ResponseCompletionHandler?){
        request(remoteUrl + "getForm",parameters:["code":code.marks,"groupkey":groupkey.marks],callBack:callBack)
    }
    
    //username:String,
    static func audit(code:String,action:String,remark:String,userCode:String,groupkey:String,callBack:ResponseCompletionHandler?){
        request(remoteUrl + "audit",parameters:["code":code.marks,"action":action.marks,"remark":remark.marks,"staffCode":userCode.marks,"groupkey":groupkey.marks],callBack:callBack)//"staffname":username.marks,
    }
    
    static func getHelpInfo(callBack:ResponseCompletionHandler?){
        request(remoteUrl + "getHelpInfo",callBack:callBack)
    }
    
//    private static func modifyParameters(var parameters:Dictionary<String,AnyObject>)->Dictionary<String,AnyObject>{
//        for (key,value) in parameters{
////            if value is NSString{ //不做处理
////                print("value不需要加引号")
////            }else
//                if value is String{
//                parameters.updateValue("\"" + (value as! String) + "\"", forKey: key)
//            }
////            else if value is JSON {
////                modifyParameters()
////            }
//        }
//        return parameters
//    }
    
    private static func request(url:String,parameters:Dictionary<String,AnyObject>? = nil,method: Alamofire.Method = .POST,
        headers:Dictionary<String,String>? = BestRemoteFacade.headers,callBack:ResponseCompletionHandler? = nil){
        Alamofire.request(method, url , parameters: parameters, headers: headers).responseJSON { (response) -> Void in
            if response.result.isSuccess{
                if let value = response.result.value {
                    let json = JSON(value)
//                    print("JSON: \(json)")
                    if callBack != nil{
                        callBack!(json: json,isSuccess:true,error:nil)
                    }
                }
            }else if response.result.isFailure{
                if callBack != nil{
                    callBack!(json: nil,isSuccess:false,error:response.result.error)
                }
                print("数据接收失败:" + response.result.error!.description)
            }
        }
    }
    
    private static func generateParameter(inout parameters:Dictionary<String,AnyObject>,key:String,value:String){
        parameters.updateValue("\"" + value + "\"", forKey: key)
    }

}
public class AppVersionVo:NSObject{
    var appversion:String = ""
    var updateurl:String = ""
    var updateremark:String = ""//版本更新说明
}
public class CommentVo:NSObject{
    var userId:String = "" //点评人的识别码（必填）
    var userAttr1:String = ""//点评人的三个额外属性（选填）
    var userAttr2:String = ""
    var userAttr3:String = ""
    var app:String = ""//系统名（必填）
    var component:String = ""//功能模块/组件（选填）
    var page:String = ""//具体页面（必填）
    var score:Int = 0//评价分值（必填）, 分数大于0分，则点评前台显示为好评，小于0分，则显示差评，等于0分，则显示为留言
    var detail:String = ""//具体的评价描述（好评选填，差评必填）
    var submitTime:String = ""//定评时间（必填） 传递时的日期格式为YYYY-MM-DD HH:MI:SS
}


