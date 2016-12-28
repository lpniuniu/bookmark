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

class BookSlider: UISlider {

    let cancelAnimationView:BookSliderCancelAnimationView = BookSliderCancelAnimationView()
    var timer:Timer? = nil
    var bookData:BookData? = nil
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let trans = CGAffineTransform(rotationAngle: CGFloat(M_PI)/2.0)
        self.cancelAnimationView.transform = trans;
        
        weak var weakSelf = self
        Bulb.bulbGlobal().register(BookSliderCancelAnimationViewTouchSignal().on(), foreverblock: { (firstData:Any?, identfier2Signal:[String : BulbSignal]?) -> Bool in
            weakSelf?.cancelAnimationView.removeFromSuperview()
            weakSelf?.cancelAnimationView.snp.removeConstraints()
            weakSelf?.layer.removeAllAnimations()
            weakSelf?.alpha = 1
            return true
        })
        
        self.bk_addEventHandler({ (sender:Any) in
            print("\((sender as! BookSlider).value)")
            let realm = try! Realm()
            try! realm.write({
                self.bookData?.pageCurrent = Int((sender as! BookSlider).value)
            })
            Bulb.bulbGlobal().fire(BookChangePageValue().on(), data: self.bookData!)
            self.pushAnimation()
        }, for: .valueChanged)
        
        Bulb.bulbGlobal().register(BookListDidSelectSignal().on(), foreverblock: { (firstData:Any?, identfier2Signal:[String : BulbSignal]?) -> Bool in
            weakSelf?.cancelAnimationView.removeFromSuperview()
            weakSelf?.cancelAnimationView.snp.removeConstraints()
            weakSelf?.layer.removeAllAnimations()
            weakSelf?.alpha = 1
            weakSelf?.timer?.invalidate()
            weakSelf?.timer = nil

            weakSelf?.bookData = firstData as? BookData
            weakSelf?.minimumValue = 0
            weakSelf?.maximumValue = Float((weakSelf?.bookData!.pageTotal)!)
            weakSelf?.setValue(Float((weakSelf?.bookData!.pageCurrent)!), animated: true)
            
            return true
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pushAnimation() {
        if (timer != nil) {
            timer?.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer:Timer) in
            self.superview?.addSubview(self.cancelAnimationView)
            self.cancelAnimationView.snp.makeConstraints { (maker:ConstraintMaker) in
                maker.edges.equalTo(self)
            }
            self.fadeOut()
        }
    }
    
    func fadeOut() {
        alpha = 1
        UIView.animate(withDuration: 3, animations: {
            self.alpha = 0
        }) { (complete:Bool) in
            self.cancelAnimationView.removeFromSuperview()
            self.cancelAnimationView.snp.removeConstraints()
        }
    }
}
