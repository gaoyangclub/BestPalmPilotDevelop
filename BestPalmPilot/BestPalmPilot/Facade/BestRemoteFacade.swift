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
    
    private static let remoteUrl = "http://10.45.10.198:8282/gateway/rest/api/com.best.oasis.husky.ws.mobile.MobileWebService/"
    private static let headers:Dictionary<String,String> = ["X-Route-User":"TEST","X-Route-Token":"TEST"]
    
    static func login(username:String,password:String,appid:String,mobileInfo:String,callBack:ResponseCompletionHandler?){
        request(remoteUrl + "login",parameters:modifyParameters(["username":username,"password":password,"appid":appid,"mobileInfo":mobileInfo]),callBack:callBack)
    }
    
    private static func modifyParameters(var parameters:Dictionary<String,AnyObject>)->Dictionary<String,AnyObject>{
        for (key,value) in parameters{
            if value is String{
                parameters.updateValue("\"" + (value as! String) + "\"", forKey: key)
            }
        }
        return parameters
    }
    
    private static func request(url:String,parameters:Dictionary<String,AnyObject>,method: Alamofire.Method = .POST,callBack:ResponseCompletionHandler? = nil){
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
//                print("数据接收失败:" + response.result.error!.description)
            }
        }
    }
    
    private static func generateParameter(inout parameters:Dictionary<String,AnyObject>,key:String,value:String){
        parameters.updateValue("\"" + value + "\"", forKey: key)
    }

}
