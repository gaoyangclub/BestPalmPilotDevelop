//
//  BestRemoteFacade.swift
//  AlamofireTest
//
//  Created by admin on 16/1/12.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit
import Alamofire

typealias ResponseCompletionHandler = (json:JSON?,isSuccess:Bool,error:NSError?)->Void

class BestRemoteFacade: AnyObject {
    
    private static let appUrl = "http://itunes.apple.com/"
    
    private static let appId = "776882837"
    
    private static let remoteUrl = "http://10.45.10.198:8282/gateway/rest/api/com.best.oasis.husky.ws.mobile.MobileWebService/"
    private static let headers:Dictionary<String,String> = ["X-Route-User":"TEST","X-Route-Token":"TEST"]
    
    static func getAppVersion(callBack:ResponseCompletionHandler?){
        request(appUrl + "lookup",parameters:["id":appId],headers:nil,callBack:callBack)
    }
    
    static func login(username:String,password:String,appid:String,mobileInfo:String,callBack:ResponseCompletionHandler?){
        request(remoteUrl + "login",parameters:["username":username.getMarks(),"password":password.getMarks(),"appid":appid.getMarks(),"mobileInfo":mobileInfo.getMarks()],callBack:callBack)
    }
    
    static func getApproveMenu(username:String,callBack:ResponseCompletionHandler?){
        request(remoteUrl + "getAppMenu",parameters:["username":username.getMarks()],callBack:callBack)
    }
    
    static func getListFormInfos(so:FormListSO,groupkey:String,callBack:ResponseCompletionHandler?){
        request(remoteUrl + "getListFormInfos",parameters:["so":so.getJsonString(),"groupkey":groupkey.getMarks()],
            callBack:callBack)
    }
    
    static func getFormDetailsVo(code:String,groupkey:String,callBack:ResponseCompletionHandler?){
        request(remoteUrl + "getForm",parameters:["code":code.getMarks(),"groupkey":groupkey.getMarks()],callBack:callBack)
    }
    
    //username:String,
    static func audit(code:String,action:String,remark:String,userCode:String,groupkey:String,callBack:ResponseCompletionHandler?){
        request(remoteUrl + "audit",parameters:["code":code.getMarks(),"action":action.getMarks(),"remark":remark.getMarks(),"staffcode":userCode.getMarks(),"groupkey":groupkey.getMarks()],callBack:callBack)//"staffname":username.getMarks(),
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
