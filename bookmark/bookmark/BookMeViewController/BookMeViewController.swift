//
//  BookMeViewController.swift
//  bookmark
//
//  Created by familymrfan on 17/1/9.
//  Copyright © 2017年 niuniu. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift
import UserNotifications
import Bulb

class BookMeViewController: FormViewController {

    var notiAuth = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let realm = try! Realm()
        let results = realm.objects(BookSettingData.self);
        var dict = [String:BookSettingData]()
        for result in results {
            dict[result.key!] = result
        }
        view.backgroundColor = UIColor.white
        
        title = "我"
        
        let signal:BulbBoolSignal? = Bulb.bulbGlobal().getSignalFromHungUpList(AuthNotiSignal.identifier()) as? BulbBoolSignal
        notiAuth =  signal != nil && signal!.isOn()
        form = Section()
            <<< SwitchRow(){
                $0.title = "鼓励提醒(连续阅读3天)"
                if notiAuth == false {
                    $0.value = false
                } else {
                    $0.value = dict["encourage_switch"]!.value == "1"
                }
                }.onChange({ (row:SwitchRow) in
                
                let realm = try! Realm()
                try! realm.write {
                    if row.value == false {
                        dict["encourage_switch"]!.value = "0"
                    } else {
                        if self.notiAuth == false {
                            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)! , options: [:], completionHandler: nil)
                            self.notiAuth = true
                        }
                        dict["encourage_switch"]!.value = "1"
                    }
                }
            })
            <<< TimeRow(){
                $0.title = "鼓励提醒时间"
                let dateFormatter = DateFormatter()
                let initialString = dict["encourage_time"]!.value!
                dateFormatter.dateFormat = "HH:mm"
                if let date = dateFormatter.date(from: initialString) {
                    $0.value = date
                }
                }.onChange({ (row:TimeRow) in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm"
                    let dateString = dateFormatter.string(from: row.value!)
                    let realm = try! Realm()
                    try! realm.write {
                        dict["encourage_time"]!.value = dateString
                    }
            })
            <<< SwitchRow(){
                $0.title = "督促提醒(两天没有阅读)"
                if notiAuth == false {
                    $0.value = false
                } else {
                    $0.value = dict["urge_switch"]!.value == "1"
                }
                }.onChange({ (row:SwitchRow) in
                
                let realm = try! Realm()
                try! realm.write {
                    if row.value == false {
                        dict["urge_switch"]!.value = "0"
                    } else {
                        if self.notiAuth == false {
                            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)! , options: [:], completionHandler: nil)
                            self.notiAuth = true
                        }
                        dict["urge_switch"]!.value = "1"
                    }
                }
            })
            <<< TimeRow(){
                $0.title = "督促提醒时间"
                let dateFormatter = DateFormatter()
                let initialString = dict["urge_time"]!.value!
                dateFormatter.dateFormat = "HH:mm"
                if let date = dateFormatter.date(from: initialString) {
                    $0.value = date
                }
                }.onChange({ (row:TimeRow) in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm"
                    let dateString = dateFormatter.string(from: row.value!)
                    let realm = try! Realm()
                    try! realm.write {
                        dict["urge_time"]!.value = dateString
                    }
            })
            +++ Section()
            <<< ButtonRow(){
                $0.title = "关于"
            }.cellUpdate({ (cell, row) in
                cell.textLabel?.textAlignment = .left
                cell.textLabel?.textColor = UIColor.black
            }).onCellSelection({ (cell, row) in
                self.navigationController?.pushViewController(BookAboutViewController(), animated: true)
            })
            <<< ButtonRow(){
                $0.title = "意见反馈"
                }.cellUpdate({ (cell, row) in
                    cell.textLabel?.textAlignment = .left
                    cell.textLabel?.textColor = UIColor.black
                }).onCellSelection({ (cell, row) in
                    self.navigationController?.pushViewController(BookFeedBackViewController(), animated: true)
                })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let un = UNUserNotificationCenter.current()
        un.getNotificationSettings { (settings:UNNotificationSettings) in
            if settings.authorizationStatus != .authorized {
                self.notiAuth = false
            } else {
                self.notiAuth = true
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
