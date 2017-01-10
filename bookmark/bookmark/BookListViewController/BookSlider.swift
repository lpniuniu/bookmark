//
//  BookSlider.swift
//  bookmark
//
//  Created by familymrfan on 16/12/17.
//  Copyright © 2016年 niuniu. All rights reserved.
//

import UIKit
import BlocksKit
import SnapKit
import Bulb
import RealmSwift

// what she say
class BookChangePageValue: BulbBoolSignal {

}

class BookSlider: ArrowSlider {
    var bookData:BookData? = nil
    
    var currentDayzeroOfDate:Date{
        let calendar:Calendar = Calendar.current
        let date = Date()
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)

        var components:DateComponents = DateComponents()
        
        components.timeZone = NSTimeZone.local
        components.year = year
        components.month = month
        components.day = day
        components.hour = 8
        components.minute = 0
        components.second = 0
        
        return calendar.date(from: components)!
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        weak var weakSelf = self
        
        self.valueChangeBlock = { (value:Int) in
            let realm = try! Realm()
            
            
            try! realm.write({
                self.bookData?.pageCurrent = value
            })
            Bulb.bulbGlobal().fire(BookChangePageValue.signalDefault(), data: self.bookData!)
            
            let result = realm.objects(BookReadDateData.self).filter("date == %@", self.currentDayzeroOfDate)
            guard result.count == 0 else {
                return
            }
            let readDate = BookReadDateData()
            readDate.date = self.currentDayzeroOfDate
            try! realm.write({
                realm.add(readDate)
            })
        }
        
        Bulb.bulbGlobal().register(BookListDidSelectSignal.signalDefault(), foreverblock: { (firstData:Any?, identfier2Signal:[String : BulbSignal]?) -> Bool in

            weakSelf?.showSlider()
            weakSelf?.bookData = firstData as? BookData
            weakSelf?.maxValue = (weakSelf?.bookData!.pageTotal)!
            weakSelf?.refreshValue(value: (weakSelf?.bookData!.pageCurrent)!)
            return true
        })
        
        Bulb.bulbGlobal().register(BookListDidDeselectSignal.signalDefault(), foreverblock: { (firstData:Any?, identfier2Signal:[String : BulbSignal]?) -> Bool in
            weakSelf?.hideSlider()
            return true
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hideSlider() {
        isHidden = true
    }
    
    func showSlider() {
        isHidden = false
    }
}
