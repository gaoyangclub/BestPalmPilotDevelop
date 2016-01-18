//
//  BestUtils.swift
//  BestPalmPilot
//
//  Created by admin on 16/1/15.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit

public class BestUtils:AnyObject {

    public static let themeColor = FlatUIColors.peterRiverColor()//UIColor(red: 81/255, green: 121/255, blue: 178/255, alpha: 1)
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    
    
    public static func generateObjByJson(json:JSON,classType:NSObject.Type)->NSObject{
        let obj = classType.init()
        for (key,value) in json{
            obj.setValue(value.object, forKey: key)
        }
        return obj
    }

}
