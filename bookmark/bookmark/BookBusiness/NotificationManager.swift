//
//  NotificationManager.swift
//  bookmark
//
//  Created by familymrfan on 17/1/17.
//  Copyright © 2017年 niuniu. All rights reserved.
//
import UserNotifications
import Bulb
import RealmSwift

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
    
    class func sendUrge() {
        let identifier = "BookSendUrgeNotiIdentifier"
        let un = UNUserNotificationCenter.current()
        un.removePendingNotificationRequests(withIdentifiers: [identifier])
        
        let content = UNMutableNotificationContent()
        content.title = "该读书了"
        content.body = "记得保持每天阅读的习惯哦!"
        content.sound = UNNotificationSound.default()
        
        let realm = try! Realm()
        let results = realm.objects(BookSettingData.self);
        var dict = [String:BookSettingData]()
        for result in results {
            dict[result.key!] = result
        }
        
        if dict["urge_switch"]!.value == "1" {
            let dateFormatter = DateFormatter()
            let initialString = dict["urge_time"]!.value!
            dateFormatter.dateFormat = "HH:mm"
            let date = dateFormatter.date(from: initialString)!
            let triggerDaily = Calendar.current.dateComponents([.hour,.minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            un.add(request, withCompletionHandler:nil)
        }
    }
}

