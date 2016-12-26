//
//  bookmarkTests.swift
//  bookmarkTests
//
//  Created by FanFamily on 2016/12/13.
//  Copyright © 2016年 niuniu. All rights reserved.
//

import XCTest
@testable import bookmark

class bookmarkTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRealm() {
        let book:BookData = BookData()
        book.name = "网易一千零一夜"
        book.photo = nil
        book.pageCurrent = 0
        book.pageTotal = 300
        DataMaster.addBook(data: book)
        
        let books = DataMaster.getBooks()
        print(books)
    }
    
}
