//
//  UserDefaultCache.swift
//  BestPalmPilot
//
//  Created by admin on 16/1/14.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit

class UserDefaultCache: AnyObject {
    
    static func getUsername()->String?{
        return getUserDataByKey("username") as? String
    }
    static func setUsername(value:String?){
        setUserDataByKey("username",value: value)
    }
    static func getPassword()->String?{
        return getUserDataByKey("password") as? String
    }
    static func setPassword(value:String?){
        setUserDataByKey("password",value: value)
    }
    static func getToken()->String?{
        return getUserDataByKey("token") as? String
    }
    static func setToken(value:String?){
        setUserDataByKey("token",value: value)
    }
    /** 清除用户缓存 */
    static func clearUser(){
        setUsername(nil)
        setPassword(nil)
        setToken(nil)
//        let userDefault = NSUserDefaults.standardUserDefaults()
//        userDefault.setNilValueForKey("username")
//        userDefault.setNilValueForKey("password")
//        userDefault.setNilValueForKey("token")
    }
    
    static func hasUser()->Bool{
        return getUsername() != nil && getPassword() != nil && getToken() != nil
    }
    
    private static func getUserDataByKey(key:String)->AnyObject?{
        let userDefault = NSUserDefaults.standardUserDefaults()
        return userDefault.objectForKey(key)
    }
    
    private static func setUserDataByKey(key:String,value:AnyObject?){
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setObject(value, forKey: key)
    }
    
    
    

}
