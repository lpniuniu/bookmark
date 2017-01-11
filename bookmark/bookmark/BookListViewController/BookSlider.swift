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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        weak var weakSelf = self
        
        self.valueChangeBlock = { (value:Int) in
            let realm = try! Realm()
            
            
            try! realm.write({
                self.bookData?.pageCurrent = value
            })
            Bulb.bulbGlobal().fire(BookChangePageValue.signalDefault(), data: self.bookData!)
            
            let now = Date()
            let result = realm.objects(BookReadDateData.self).filter("date == %@", now.zeroOfDate)
            guard result.count == 0 else {
                return
            }
            let readDate = BookReadDateData()
            readDate.date = now.zeroOfDate
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
