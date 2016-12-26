//
//  DataMaster.swift
//  bookmark
//
//  Created by familymrfan on 16/12/26.
//  Copyright © 2016年 niuniu. All rights reserved.
//

import UIKit
import RealmSwift

class DataMaster {
    // add a book
    class func addBook(data:BookData) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(data)
        }
    }
    
    class func getBooks() -> [BookData] {
        let realm = try! Realm()
        let objs:Results<BookData> = realm.objects(BookData.self)
        var books = [BookData]()
        for n in 0..<objs.count {
            books.append(objs[n])
            
        }
        return books
    }
}
