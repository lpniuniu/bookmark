//
//  BookData.swift
//  bookmark
//
//  Created by familymrfan on 16/12/26.
//  Copyright © 2016年 niuniu. All rights reserved.
//

import UIKit
import RealmSwift

class BookData: Object {
    dynamic var serverId:String = ""
    dynamic var name:String = ""
    dynamic var photoUrl:String? = nil
    dynamic var pageCurrent:Int = 0
    dynamic var pageTotal:Int = 0
    dynamic var done:Bool = false
    dynamic var doneDate:Date? = nil
}
