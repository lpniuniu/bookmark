//
//  BookListTableView.swift
//  bookmark
//
//  Created by FanFamily on 16/12/14.
//  Copyright © 2016年 niuniu. All rights reserved.
//

import UIKit
import SnapKit
import Bulb
import SWTableViewCell
import RealmSwift

// what she say
class BookListDidSelectSignal: BulbBoolSignal {
    override class func description() -> String {
        return "BookList is selected";
    }
}

class BookListDidDeselectSignal: BulbBoolSignal {
    override class func description() -> String {
        return "BookList is not selected";
    }
}

class BookListTableView: UITableView, UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate {
    
    let cellIdentifier:String = "book_list_cellIdentifier"
    var selectIndexPath:IndexPath? = nil
    
    override init(frame:CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        delegate = self
        dataSource = self
        separatorStyle = .none
        register(BookCell.self, forCellReuseIdentifier: cellIdentifier)
        showsVerticalScrollIndicator = false
        
        weak var weakSelf = self
        Bulb.bulbGlobal().register(BookSavedSignal.signalDefault()) { (book:Any?, identifier2Signal:[String : BulbSignal]?) -> Bool in
            weakSelf?.reloadData()
            
            if weakSelf?.selectIndexPath != nil {
                weakSelf?.selectRow(at: weakSelf?.selectIndexPath, animated: true, scrollPosition: .none)
            }
            return true
        }
        
        Bulb.bulbGlobal().register(BookChangePageValue.signalDefault()) { (book:Any?, identifier2Signal:[String : BulbSignal]?) -> Bool in
            weakSelf?.reloadData()
            
            if weakSelf?.selectIndexPath != nil {
                weakSelf?.selectRow(at: weakSelf?.selectIndexPath, animated: true, scrollPosition: .none)
            }
            return true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        return realm.objects(BookData.self).filter("done == false").count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:BookCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BookCell
        cell.configureFlatCell(with: UIColor.white, selectedColor: UIColor.greenSea(), roundingCorners:.allCorners)
        cell.cornerRadius = 5.0
        cell.separatorHeight = 20.0
        cell.backgroundColor = backgroundColor
        cell.rightUtilityButtons = rightButton() as NSArray as! [Any]
        cell.delegate = self
        
        let realm = try! Realm()
        if let imageData = realm.objects(BookData.self).filter("done == false")[indexPath.row].photo {
            cell.bookImageView.image = UIImage(data:imageData)
        } else if let imageUrl = realm.objects(BookData.self).filter("done == false")[indexPath.row].photoUrl {
            let url = URL(string: imageUrl)
            cell.bookImageView.kf.setImage(with: url)
        }
        cell.nameLabel.text = realm.objects(BookData.self).filter("done == false")[indexPath.row].name
        cell.pageLabel.text = "\(realm.objects(BookData.self).filter("done == false")[indexPath.row].pageCurrent)/\(realm.objects(BookData.self).filter("done == false")[indexPath.row].pageTotal)"
        return cell
    }
    
    func swipeableTableViewCell(_ cell: SWTableViewCell!, didTriggerRightUtilityButtonWith index: Int) {
        if index == 0 {
            let realm = try! Realm()
            let bookData = realm.objects(BookData.self).filter("done == false")[(indexPath(for: cell)?.row)!]
            
            let bookDone:BookReadDoneData = BookReadDoneData()
            bookDone.bookData = bookData
            bookDone.doneDate = Date()
            try! realm.write({
                bookData.done = true
                realm.add(bookDone)
            })
            deleteRows(at:[indexPath(for: cell)!], with: .fade)
            Bulb.bulbGlobal().fire(BookListDidDeselectSignal.signalDefault(), data:nil)
            
            // 加入日历
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
        } else if index == 1 {
            let deleteConfirmAlert = UIAlertController(title: "即将删除这本书，是否确认", message: "", preferredStyle: .alert)
            deleteConfirmAlert.view.tintColor = UIColor.greenSea()
            let confirmAction = UIAlertAction(title: "确认", style: .default, handler: { (action:UIAlertAction) in
                let realm = try! Realm()
                try! realm.write({
                    realm.delete(realm.objects(BookData.self).filter("done == false")[(self.indexPath(for: cell)?.row)!])
                })
                self.deleteRows(at:[self.indexPath(for: cell)!], with: .fade)
                Bulb.bulbGlobal().fire(BookListDidDeselectSignal.signalDefault(), data:nil)
            })
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (action:UIAlertAction) in
                
            })
            
            deleteConfirmAlert.addAction(confirmAction)
            deleteConfirmAlert.addAction(cancelAction)
            
            UIApplication.shared.keyWindow?.rootViewController?.present(deleteConfirmAlert, animated: true, completion: { 
                
            })
        }
    }
    
    func rightButton() -> NSMutableArray {
        let buttons:NSMutableArray = []
        buttons.sw_addUtilityButton(with: UIColor.turquoise(), title: "阅完")
        buttons.sw_addUtilityButton(with: UIColor.red, title: "删除")
        return buttons
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndexPath = indexPath
        let realm = try! Realm()
        Bulb.bulbGlobal().fire(BookListDidSelectSignal.signalDefault(), data: realm.objects(BookData.self).filter("done == false")[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectIndexPath = nil
        let realm = try! Realm()
        Bulb.bulbGlobal().fire(BookListDidDeselectSignal.signalDefault(), data: realm.objects(BookData.self).filter("done == false")[indexPath.row])
    }
}
