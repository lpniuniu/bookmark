//
//  BookListDidSelectSignal.swift
//  bookmark
//
//  Created by FanFamily on 16/12/17.
//  Copyright © 2016年 niuniu. All rights reserved.
//

import UIKit
import Bulb

class BookListDidSelectSignal: BulbBoolSignal {
    override class func description() -> String {
        return "BookList is selected";
    }
}
