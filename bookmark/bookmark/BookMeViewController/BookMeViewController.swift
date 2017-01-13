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
        var dict = [String:String]()
        for result in results {
            dict[result.key!] = result.value!
        }
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        form = Section("提醒")
            <<< SwitchRow(){
                $0.title = "鼓励提醒"
                $0.value = dict["encourage_switch"]! == "1"
            }
            <<< TimeRow(){
                $0.title = "鼓励提醒时间"
                let dateFormatter = DateFormatter()
                let initialString = dict["encourage_time"]!
                dateFormatter.dateFormat = "HH:mm"
                if let date = dateFormatter.date(from: initialString) {
                    $0.value = date
                }
            }
            <<< SwitchRow(){
                $0.title = "督促提醒"
                $0.value = dict["urge_switch"]! == "1"
            }
            <<< TimeRow(){
                $0.title = "督促提醒时间"
                let dateFormatter = DateFormatter()
                let initialString = dict["urge_time"]!
                dateFormatter.dateFormat = "HH:mm"
                if let date = dateFormatter.date(from: initialString) {
                    $0.value = date
                }
            }
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
