//
//  BookReadDoneData.swift
//  bookmark
//
//  Created by familymrfan on 17/1/11.
//  Copyright © 2017年 niuniu. All rights reserved.
//

import UIKit
import RealmSwift

class BookReadDoneData: Object {
    dynamic var bookData:BookData?
    dynamic var doneDate:Date?
}
