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
    
    private class func calcContinuousRead() -> Int {
        var count = 0
        let realm = try! Realm()
        let result = realm.objects(BookReadDateData.self).filter("date >= %@", Date().startMonthOfDate).filter("date <= %@", Date().endMonthOfDate)
        var dateCurrent = Date()
        while dateCurrent >= Date().startMonthOfDate {
            var find = false
            for r in result {
                if r.date == dateCurrent.zeroOfDate {
                    find = true
                    break
                }
            }
            if find == false {
                break
            } else {
                count = count + 1
            }
            dateCurrent = Date(timeInterval: -3600*24, since: dateCurrent)
        }
        return count
    }
    
    private class func calcContinuousUnRead() -> Int {
        var count = 0
        let realm = try! Realm()
        let result = realm.objects(BookReadDateData.self).filter("date >= %@", Date().startMonthOfDate).filter("date <= %@", Date().endMonthOfDate)
        var dateCurrent = Date()
        while dateCurrent >= Date().startMonthOfDate {
            var find = false
            for r in result {
                if r.date == dateCurrent.zeroOfDate {
                    find = true
                    break
                }
            }
            if find == false {
                count = count + 1
            } else {
                break
            }
            dateCurrent = Date(timeInterval: -3600*24, since: dateCurrent)
        }
        return count
    }
    
    class func sendEncourageNoti() {
        
        let identifier = "BookSendEncourageNotiIdentifier"
        let un = UNUserNotificationCenter.current()
        un.removePendingNotificationRequests(withIdentifiers: [identifier])
        
        // 连续阅读小于三天，不做鼓励提醒
        let continuousRead =  self.calcContinuousRead()
        if continuousRead < 3 {
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "恭喜您"
        content.body = "您已经保持连续阅读\(continuousRead)天，再接再厉"
        content.sound = UNNotificationSound.default()
        
        let realm = try! Realm()
        let results = realm.objects(BookSettingData.self);
        var dict = [String:BookSettingData]()
        for result in results {
            dict[result.key!] = result
        }
        
        if dict["encourage_switch"]!.value == "1" {
            let dateFormatter = DateFormatter()
            let initialString = dict["encourage_time"]!.value!
            dateFormatter.dateFormat = "HH:mm"
            let date = dateFormatter.date(from: initialString)!
            let triggerDaily = Calendar.current.dateComponents([.hour,.minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            un.add(request, withCompletionHandler:nil)
        }
    }
    
    class func sendUrge() {
        let identifier = "BookSendUrgeNotiIdentifier"
        let un = UNUserNotificationCenter.current()
        un.removePendingNotificationRequests(withIdentifiers: [identifier])
        
        // 连续不阅读小于二天，不做鼓励提醒
        let continuousUnRead =  self.calcContinuousUnRead()
        if continuousUnRead < 2 {
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "最近怎么了"
        content.body = "您已经连续\(continuousUnRead)天没有阅读了, 赶快拿起书本"
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

