//
//  BookDoneListTableView.swift
//  bookmark
//
//  Created by familymrfan on 17/1/11.
//  Copyright © 2017年 niuniu. All rights reserved.
//

import UIKit
import SnapKit
import Bulb
import SWTableViewCell
import RealmSwift

class BookDoneListTableView: UITableView, UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate {

    let cellIdentifier:String = "book_done_list_cellIdentifier"
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        delegate = self
        dataSource = self
        register(BookDoneCell.self, forCellReuseIdentifier: cellIdentifier)
        showsVerticalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        return realm.objects(BookData.self).filter("done == true").count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BookDoneCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BookDoneCell
        cell.backgroundColor = backgroundColor
        cell.rightUtilityButtons = rightButton() as NSArray as? [Any]
        cell.delegate = self
        
        let realm = try! Realm()
        let result = realm.objects(BookData.self).filter("done == true")[indexPath.row]
        
        if let imageUrl = result.photoUrl {
            let url = URL(string: imageUrl)
            if (url?.scheme == "http" || url?.scheme == "https") {
                cell.bookImageView.kf.setImage(with: url)
            } else {
                let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                let photoPath = doc?.appendingPathComponent("photos")
                cell.bookImageView.image = UIImage(contentsOfFile: (photoPath?.appendingPathComponent((url?.path)!).path)!)
            }
        }
        
        cell.nameLabel.text = result.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        cell.doneDateLabel.text = dateFormatter.string(from: result.doneDate!)
        return cell
    }
    
    func rightButton() -> NSMutableArray {
        let buttons:NSMutableArray = []
        buttons.sw_addUtilityButton(with: UIColor.red, title: "删除")
        return buttons
    }
    
    func swipeableTableViewCell(_ cell: SWTableViewCell!, didTriggerRightUtilityButtonWith index: Int) {
        let realm = try! Realm()
        let bookData = realm.objects(BookData.self).filter("done == true")[(indexPath(for: cell)?.row)!]
        try! realm.write({                                                                                    
            realm.delete(bookData)
        })
        deleteRows(at:[indexPath(for: cell)!], with: .fade)
    }
}
