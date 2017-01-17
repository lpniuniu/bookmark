//
//  AppDelegate.swift
//  bookmark
//
//  Created by FanFamily on 2016/12/13.
//  Copyright © 2016年 niuniu. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        prepareRealm()
        
        return true
    }
    
    func prepareRealm() {
        var config = Realm.Configuration.defaultConfiguration
        config.schemaVersion = 1
        Realm.Configuration.defaultConfiguration = config
        
        let realm = try! Realm()
        if realm.objects(BookSettingData.self).count == 0 {
            let encourage_switch_data = BookSettingData()
            encourage_switch_data.key = "encourage_switch"
            encourage_switch_data.value = "1"
            try! realm.write({
                realm.add(encourage_switch_data)
            })
            let encourage_time_data = BookSettingData()
            encourage_time_data.key = "encourage_time"
            encourage_time_data.value = "21:00"
            try! realm.write({
                realm.add(encourage_time_data)
            })
            let urge_switch_data = BookSettingData()
            urge_switch_data.key = "urge_switch"
            urge_switch_data.value = "1"
            try! realm.write({
                realm.add(urge_switch_data)
            })
            let urge_time_data = BookSettingData()
            urge_time_data.key = "urge_time"
            urge_time_data.value = "21:00"
            try! realm.write({
                realm.add(urge_time_data)
            })
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        
        let tabVC = UITabBarController()
        
        let listVC = UINavigationController(rootViewController: BookListViewController())
        listVC.tabBarItem.title = "书单"
        let readshowVC = BookReadShowViewController()
        readshowVC.tabBarItem.title = "阅历"
        let meVC = BookMeViewController()
        meVC.tabBarItem.title = "我"
        
        tabVC.viewControllers = [listVC, readshowVC, meVC]
        
        window?.rootViewController = tabVC
        window?.backgroundColor = UIColor.gray
        window?.makeKeyAndVisible()
        
        NotificationManager.registerNotification()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        NotificationManager.sendEncourageNoti()
        NotificationManager.sendUrge()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

