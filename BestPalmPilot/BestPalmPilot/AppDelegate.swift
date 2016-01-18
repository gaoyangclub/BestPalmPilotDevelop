//
//  AppDelegate.swift
//  BestPalmPilot
//
//  Created by admin on 16/1/14.
//  Copyright © 2016年 admin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let mainFrame = UIScreen.mainScreen().bounds
        
        JLToastView.setDefaultValue(mainFrame.height / 2, forAttributeName: JLToastViewPortraitOffsetYAttributeName, userInterfaceIdiom: .Phone)
        JLToastView.setDefaultValue(mainFrame.width / 2, forAttributeName: JLToastViewLandscapeOffsetYAttributeName, userInterfaceIdiom: .Phone)
        JLToastView.setDefaultValue(UIFont.systemFontOfSize(20), forAttributeName: JLToastViewFontAttributeName, userInterfaceIdiom: .Phone)
        
        IQKeyboardManager.sharedManager().enable = true
        
        self.window = UIWindow(frame: mainFrame)
        // Override point for customization after application launch.
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        let main:RootNavigationControl = RootNavigationControl.getInstance()
        main.navigationColor = BestUtils.themeColor//FlatUIColors.cloudsColor()//UIColor(red: 90 / 255, green: 115 / 255, blue: 169 / 255, alpha: 0.5) //
        main.setViewControllers([RootViewController()], animated: false)
        //        let main = RootNavigationControl(rootViewController:RootViewController())
        
        let drawerController = RootDrawerController.getInstance()
        drawerController.centerViewController = main
        drawerController.rightDrawerViewController = AViewController()
        
        drawerController.showsShadow = true
        drawerController.maximumRightDrawerWidth = 200
        drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureMode.None
        drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.All
        drawerController.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionMode.None
        
        self.window!.rootViewController = drawerController
        
        return true
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

