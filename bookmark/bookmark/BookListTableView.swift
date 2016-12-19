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
        return 10
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
        cell.delegate = self
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
