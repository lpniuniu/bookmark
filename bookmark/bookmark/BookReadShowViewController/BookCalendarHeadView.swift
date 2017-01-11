//
//  BookCalendarHeadView.swift
//  bookmark
//
//  Created by familymrfan on 17/1/10.
//  Copyright © 2017年 niuniu. All rights reserved.
//

import UIKit
import JTAppleCalendar
import SnapKit
import Bulb

class BookCalendarHeadView: JTAppleHeaderView {

    let monthLabel:UILabel = UILabel()
    let headTitles:[String] = ["日", "一", "二", "三", "四", "五", "六"]
    var titleLabels:[UILabel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(monthLabel)
        
        var i = 0
        for _ in 1...7 {
            let label = UILabel()
            label.text = headTitles[i]
            titleLabels.append(label)
            addSubview(label)
            i = i + 1
        }
        
        monthLabel.textAlignment = .center
        
        weak var weakSelf = self
        Bulb.bulbGlobal().register(BookCalendarChangeMonthSignal.signalDefault()) { (data:Any?, identifier2Signal:[String : BulbSignal]?) -> Bool in
            let date:Date = (data as? Date)!
            let month = Calendar.current.dateComponents([.month], from: date).month!
            let monthName = DateFormatter().monthSymbols[(month-1) % 12]
            // 0 indexed array
            let year = Calendar.current.component(.year, from: date)
            
            if let monthLabel = weakSelf?.monthLabel {
                monthLabel.text = monthName + " " + String(year)
            } else {
                return false
            }
            return true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        monthLabel.snp.makeConstraints { (maker:ConstraintMaker) in
            maker.top.equalToSuperview().offset(10)
            maker.left.right.equalToSuperview()
            maker.height.equalTo(15)
        }
        
        var preLabel:UILabel? = nil
        for label:UILabel in titleLabels {
            label.snp.remakeConstraints({ (maker:ConstraintMaker) in
                if preLabel == nil {
                    maker.left.equalToSuperview()
                } else {
                    maker.left.equalTo((preLabel?.snp.right)!)
                }
                maker.width.equalTo(frame.width/7.0)
                maker.height.equalToSuperview()
                maker.top.equalTo(monthLabel.snp.bottom)
            })
            preLabel = label
        }
    }

}
