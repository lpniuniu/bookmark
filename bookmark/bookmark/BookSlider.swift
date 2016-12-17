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

class BookSlider: UISlider {

    let cancelAnimationView:UIView = UIView()
    var timer:Timer? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let trans = CGAffineTransform(rotationAngle: CGFloat(M_PI)/2.0)
        self.cancelAnimationView.transform = trans;
        
        self.bk_addEventHandler({ (sender:Any) in
            print("\((sender as! BookSlider).value)")
            self.pushAnimation()
        }, for: .valueChanged)
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
            self.cancelAnimationView.bk_(whenTapped: {
                self.cancelAnimationView.removeFromSuperview()
                self.cancelAnimationView.snp.removeConstraints()
                self.layer.removeAllAnimations()
                self.alpha = 1
            })
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
