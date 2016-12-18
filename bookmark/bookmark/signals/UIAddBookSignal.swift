//
//  AddBookSignal.swift
//  bookmark
//
//  Created by FanFamily on 16/12/18.
//  Copyright © 2016年 niuniu. All rights reserved.
//

import UIKit
import Bulb

class UIAddBookSignal: BulbBoolSignal {
    override class func description() -> String {
        return "ui want save a book";
    }
}
