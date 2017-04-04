//
//  AppDelegate.swift
//  bookmark
//
//  Created by FanFamily on 2016/12/13.
//  Copyright © 2016年 niuniu. All rights reserved.
//

import UIKit
import RealmSwift
import Crashlytics
import Fabric

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func prepareRealm() {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 2) {
                    migration.enumerateObjects(ofType: BookData.className()) { oldObject, newObject in
                        let photoUrl = oldObject!["photoUrl"] as? String
                        if (photoUrl == nil) {
                            let image = UIImage(named: "book_default")
                            let data:Data? = UIImagePNGRepresentation(image!) as Data?
                            if let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                                let photoPath = doc.appendingPathComponent("photos")
                                
                                try? FileManager.default.createDirectory(atPath: photoPath.path, withIntermediateDirectories: false, attributes: nil)
                                
                                let url = photoPath.appendingPathComponent("book_default")
                                try? data?.write(to: url);
                                newObject!["photoUrl"] = "book_default"
                            }
                        }
                    }
                }
        })
        
        let realm = try! Realm()
        if realm.objects(BookSettingData.self).count == 0 {
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
        
        Fabric.sharedSDK().debug = true
        Fabric.with([Crashlytics.self])
        
        prepareRealm()
        
        UINavigationBar.appearance().backgroundColor = UIColor.white
        UIBarButtonItem.appearance().tintColor = UIColor.black
        
        window = UIWindow()
        
        let tabVC = UITabBarController()
        
        let listVC = UINavigationController(rootViewController: BookListViewController())
        listVC.tabBarItem.title = "书单"
        listVC.tabBarItem.image = UIImage(named: "book_1")
        let readshowVC = BookReadShowViewController()
        readshowVC.tabBarItem.title = "阅历"
        readshowVC.tabBarItem.image = UIImage(named: "book_2")
        let meVC = UINavigationController(rootViewController: BookMeViewController())
        meVC.tabBarItem.title = "我"
        meVC.tabBarItem.image = UIImage(named: "me")
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

