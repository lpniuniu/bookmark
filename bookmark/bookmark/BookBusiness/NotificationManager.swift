//
//  NotificationManager.swift
//  bookmark
//
//  Created by familymrfan on 17/1/17.
//  Copyright © 2017年 niuniu. All rights reserved.
//
import UserNotifications
import Bulb

class AuthNotiSignal : BulbBoolSignal {
    
}

class NotificationManager {
    
    class func registerNotification() {
        let un = UNUserNotificationCenter.current()
        un.requestAuthorization(options: [.sound, .alert], completionHandler: { (b:Bool, error:Error?) in
            if b == true {
                Bulb.bulbGlobal().hungUp(AuthNotiSignal.signalDefault(), data: nil)
            } else {
                print("notification not open !")
            }
        })
    }
}
