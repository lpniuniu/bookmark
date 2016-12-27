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

class BookListTableView: UITableView, UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate {
    
    let cellIdentifier:String = "cellIdentifier"
    
    override init(frame:CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        delegate = self
        dataSource = self
        separatorStyle = .none
        register(SWTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        showsVerticalScrollIndicator = false
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
        
        let cell:SWTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SWTableViewCell
        cell.configureFlatCell(with: UIColor.clouds(), selectedColor: UIColor.greenSea(), roundingCorners:.allCorners)
        cell.cornerRadius = 5.0
        cell.separatorHeight = 20.0
        cell.backgroundColor = backgroundColor
        cell.rightUtilityButtons = rightButton() as NSArray as! [Any]
        let realm = try! Realm()
        cell.delegate = self
        let imageView = UIImageView(image: UIImage(named: "demo"))
        cell.addSubview(imageView)
        imageView.snp.remakeConstraints { (make:ConstraintMaker) in
            make.left.top.equalTo(cell).offset(5)
            make.bottom.equalTo(cell).offset(-25)
            make.width.equalTo(90)
        }
        let nameLabel = UILabel()
        let pageLabel = UILabel()
        cell.addSubview(nameLabel)
        cell.addSubview(pageLabel)
        nameLabel.text = realm.objects(BookData.self)[indexPath.row].name
        pageLabel.text = "\(realm.objects(BookData.self)[indexPath.row].pageCurrent)/\(realm.objects(BookData.self)[indexPath.row].pageTotal)"
        nameLabel.snp.remakeConstraints { (make:ConstraintMaker) in
            make.top.equalTo(cell).offset(5)
            make.left.equalTo(imageView.snp.right).offset(5)
            make.right.equalTo(cell).offset(-5)
            make.height.equalTo(35)
        }
        pageLabel.snp.remakeConstraints { (make:ConstraintMaker) in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(imageView.snp.right).offset(5)
            make.right.equalTo(cell).offset(-5)
            make.height.equalTo(35)
        }
        return cell
    }
    
    func swipeableTableViewCell(_ cell: SWTableViewCell!, didTriggerRightUtilityButtonWith index: Int) {
        switch index {
        case 0:
            
            break
        case 1:
            
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
        Bulb.bulbGlobal().fire(BookListDidSelectSignal().on(), data: nil)
    }
}
