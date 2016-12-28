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

class BookListTableView: UITableView, UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate {
    
    let cellIdentifier:String = "cellIdentifier"
    
    override init(frame:CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        delegate = self
        dataSource = self
        separatorStyle = .none
        register(BookCell.self, forCellReuseIdentifier: cellIdentifier)
        showsVerticalScrollIndicator = false
        
        weak var weakSelf = self
        Bulb.bulbGlobal().register(BookSavedSignal().on()) { (book:Any?, identifier2Signal:[String : BulbSignal]?) -> Bool in
            weakSelf?.reloadData()
            return true
        }
        
        Bulb.bulbGlobal().register(BookChangePageValue().on()) { (book:Any?, identifier2Signal:[String : BulbSignal]?) -> Bool in
            weakSelf?.reloadData()
            return true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        return realm.objects(BookData.self).count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:BookCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BookCell
        cell.configureFlatCell(with: UIColor.clouds(), selectedColor: UIColor.greenSea(), roundingCorners:.allCorners)
        cell.cornerRadius = 5.0
        cell.separatorHeight = 20.0
        cell.backgroundColor = backgroundColor
        cell.rightUtilityButtons = rightButton() as NSArray as! [Any]
        cell.delegate = self
        
        let realm = try! Realm()
        cell.bookImageView = UIImageView()
        if let imageData = realm.objects(BookData.self)[indexPath.row].photo {
            cell.bookImageView?.image = UIImage(data:imageData)
        }
        cell.nameLabel = UILabel()
        cell.pageLabel = UILabel()
        cell.nameLabel?.text = realm.objects(BookData.self)[indexPath.row].name
        cell.pageLabel?.text = "\(realm.objects(BookData.self)[indexPath.row].pageCurrent)/\(realm.objects(BookData.self)[indexPath.row].pageTotal)"
        return cell
    }
    
    func swipeableTableViewCell(_ cell: SWTableViewCell!, didTriggerRightUtilityButtonWith index: Int) {
        switch index {
        case 0:
            
            break
        case 1: // 删除
            let realm = try! Realm()
            try! realm.write({
                realm.delete(realm.objects(BookData.self)[(indexPath(for: cell)?.row)!])
            })
            deleteRows(at:[indexPath(for: cell)!], with: .fade)
            break
        default:
            
            break
        }
    }
    
    func rightButton() -> NSMutableArray {
        let buttons:NSMutableArray = []
        buttons.sw_addUtilityButton(with: UIColor.gray, title: "编辑")
        buttons.sw_addUtilityButton(with: UIColor.red, title: "删除")
        return buttons
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let realm = try! Realm()
        Bulb.bulbGlobal().fire(BookListDidSelectSignal().on(), data: realm.objects(BookData.self)[indexPath.row])
    }
}
