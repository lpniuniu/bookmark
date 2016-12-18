//
//  BookSliderCancelAnimationView.swift
//  bookmark
//
//  Created by FanFamily on 16/12/17.
//  Copyright © 2016年 niuniu. All rights reserved.
//

import UIKit
import Bulb

class BookSliderCancelAnimationView: UIView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        Bulb.bulbGlobal().fire(BookSliderCancelAnimationViewTouchSignal().on(), data: nil)
    }

}
