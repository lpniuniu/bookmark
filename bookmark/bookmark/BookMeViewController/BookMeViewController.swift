//
//  BookMeViewController.swift
//  bookmark
//
//  Created by familymrfan on 17/1/9.
//  Copyright © 2017年 niuniu. All rights reserved.
//

import UIKit
import Eureka

class BookMeViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        form = Section("提醒")
            <<< SwitchRow(){
                $0.title = "鼓励提醒"
                $0.value = true
            }
            <<< TimeRow(){
                $0.title = "鼓励提醒时间"
                let dateFormatter = DateFormatter()
                let initialString = "21:00:00"
                dateFormatter.dateFormat = "HH:mm:ss"
                if let date = dateFormatter.date(from: initialString) {
                    $0.value = date
                }
            }
            <<< SwitchRow(){
                $0.title = "督促提醒"
                $0.value = true
            }
            <<< TimeRow(){
                $0.title = "督促提醒时间"
                let dateFormatter = DateFormatter()
                let initialString = "21:00:00"
                dateFormatter.dateFormat = "HH:mm:ss"
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
