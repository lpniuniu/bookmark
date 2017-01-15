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

class BookMeViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let realm = try! Realm()
        let results = realm.objects(BookSettingData.self);
        var dict = [String:BookSettingData]()
        for result in results {
            dict[result.key!] = result
        }
        view.backgroundColor = UIColor.white

        form = Section("提醒")
            <<< SwitchRow(){
                $0.title = "鼓励提醒"
                $0.value = dict["encourage_switch"]!.value == "1"
                }.onChange({ (row:SwitchRow) in
                
                let realm = try! Realm()
                try! realm.write {
                    if row.value == false {
                        dict["encourage_switch"]!.value = "0"
                    } else {
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
                $0.title = "督促提醒"
                $0.value = dict["urge_switch"]!.value == "1"
                }.onChange({ (row:SwitchRow) in
                
                let realm = try! Realm()
                try! realm.write {
                    if row.value == false {
                        dict["urge_switch"]!.value = "0"
                    } else {
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
                $0.title = "记时刷新"
            }
            +++ Section()
            <<< ButtonRow(){
                $0.title = "反馈"
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
