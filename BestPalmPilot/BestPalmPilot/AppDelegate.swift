//
//  AppDelegate.swift
//  BestPalmPilot
//
//  Created by admin on 16/1/14.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UIAlertViewDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let version = (UIDevice.currentDevice().systemVersion as NSString).doubleValue
        if (version >= 8.0) { //添加通知图标等信任设置
            let types = UIUserNotificationType(rawValue: UIUserNotificationType.Badge.rawValue|UIUserNotificationType.Sound.rawValue|UIUserNotificationType.Alert.rawValue)
            let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
//            let settings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Badge, categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        }
        
        let mainFrame = UIScreen.mainScreen().bounds
        
        EZLoadingActivity.SuccessText = "提交成功"
        EZLoadingActivity.FailText = "提交失败"
        
        JLToastView.setDefaultValue(mainFrame.height / 2, forAttributeName: JLToastViewPortraitOffsetYAttributeName, userInterfaceIdiom: .Phone)
        JLToastView.setDefaultValue(mainFrame.width / 2, forAttributeName: JLToastViewLandscapeOffsetYAttributeName, userInterfaceIdiom: .Phone)
        JLToastView.setDefaultValue(UIFont.systemFontOfSize(20), forAttributeName: JLToastViewFontAttributeName, userInterfaceIdiom: .Phone)
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 60
        
        self.window = UIWindow(frame: mainFrame)
        // Override point for customization after application launch.
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        let main:RootNavigationControl = RootNavigationControl.getInstance()
        main.hairlineHidden = true
        main.navigationColor = UIColor.whiteColor()//BestUtils.themeColor//FlatUIColors.cloudsColor()//UIColor(red: 90 / 255,         green: 115 / 255, blue: 169 / 255, alpha: 0.5) //
        main.setViewControllers([RootViewController()], animated: false)
        //        let main = RootNavigationControl(rootViewController:RootViewController())
//        main.navigationBar.shadowImage = nil
        //        main.navigationBar.backIndicatorImage = nil
//        main.navigationBar.backIndicatorTransitionMaskImage = nil
        
        let drawerController = RootDrawerController.getInstance()
        drawerController.centerViewController = main
        drawerController.rightDrawerViewController = RightSideHomeController()//AccountSideHomeController()
        
        drawerController.showsShadow = true
        drawerController.maximumRightDrawerWidth = AccountSideHomeController.DrawerWidth
        drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureMode.None
        drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.All
        drawerController.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionMode.None
        
        self.window!.rootViewController = drawerController
        
        checkLastVersion()
        
        return true
    }
    
    private func checkLastVersion(){
//        let infoDic:NSDictionary = NSBundle.mainBundle().infoDictionary!
//        CFShow(infoDic)
        BestRemoteFacade.getLastVersion { [weak self] appVersionVo -> Void in
            if self == nil{
                print("AppDelegate对象已经销毁")
                return
            }
            if BestRemoteFacade.appVersion != appVersionVo.appversion{
                self!.trackViewUrl = appVersionVo.updateurl //跳转更新地址
                let alert = UIAlertView(title: "提示", message: "检测到最新版本，是否需要更新?", delegate: self, cancelButtonTitle: "确定", otherButtonTitles:"取消")
                alert.show()
            }
        }
    }
    
    private func checkAppStoreVersion(){
        let infoDic:NSDictionary = NSBundle.mainBundle().infoDictionary!
//        CFShow(infoDic)
        let appVersion:NSString = infoDic.objectForKey("CFBundleShortVersionString") as! NSString
        BestRemoteFacade.getAppStoreVersion { [weak self](json, isSuccess, error) -> Void in
            if self == nil{
                print("AppDelegate对象已经销毁")
                return
            }
            if isSuccess {
                //                print(json)
                let results:NSArray? = json?.object.valueForKey("results") as? NSArray
                if results != nil && results!.count > 0{
                    let releaseInfo:NSDictionary = results![0] as! NSDictionary
                    let latestVersion:NSString = releaseInfo.objectForKey("version") as! NSString
                    self!.trackViewUrl = releaseInfo.objectForKey("trackViewUrl") as! String
                    if appVersion != latestVersion{ //版本需要更新
                        let alert = UIAlertView(title: "提示", message: "检测到最新版本，是否需要更新?", delegate: self, cancelButtonTitle: "确定", otherButtonTitles:"取消")
                        alert.show()
                        //                        BestUtils.showAlert(message: "检测到最新版本，是否需要更新?", parentController: RootNavigationControl.getInstance(), okHandler: { _ -> Void in
                        //                            UIApplication.sharedApplication().openURL(NSURL(string: trackViewUrl)!)
                        //                        })
                    }
                }
            }
        }
    }

    private var trackViewUrl:String!
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {//选中确定
            UIApplication.sharedApplication().openURL(NSURL(string: trackViewUrl)!)
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

