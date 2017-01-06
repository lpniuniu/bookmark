//
//  BookSearchCell.swift
//  bookmark
//
//  Created by familymrfan on 17/1/6.
//  Copyright © 2017年 niuniu. All rights reserved.
//

import UIKit
import SnapKit
import BlocksKit
import Bulb
// what she say
class BookSearchCellAddBookButtonClickSignal: BulbBoolSignal {
    
}

class BookSearchCell: UITableViewCell {

    let addBookButton:UIButton = UIButton(type: .system)
    
    private var _bookImageView:UIImageView? = nil
    var bookImageView:UIImageView? {
        set {
            _bookImageView?.removeFromSuperview()
            _bookImageView = newValue
            self.addSubview(_bookImageView!)
        }
        get {
            return _bookImageView
        }
    }
    private var _nameLabel:UILabel? = nil
    var nameLabel:UILabel? {
        set {
            _nameLabel?.removeFromSuperview()
            _nameLabel = newValue
            self.addSubview(_nameLabel!)
        }
        get {
            return _nameLabel
        }
    }
    private var _pageLabel:UILabel? = nil
    var pageLabel:UILabel? {
        set {
            _pageLabel?.removeFromSuperview()
            _pageLabel = newValue
            self.addSubview(_pageLabel!)
        }
        get {
            return _pageLabel
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(addBookButton)
        addBookButton.setTitleColor(UIColor.black, for: .normal)
        addBookButton.setTitle("加入阅读", for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bookImageView?.snp.remakeConstraints { (make:ConstraintMaker) in
            make.left.top.equalTo(self).offset(5)
            make.bottom.equalTo(self).offset(-25)
            make.width.equalTo(150)
        }
        nameLabel?.snp.remakeConstraints { (make:ConstraintMaker) in
            make.top.equalTo(self).offset(5)
            make.left.equalTo((bookImageView?.snp.right)!).offset(5)
            make.right.equalTo(self).offset(-5)
            make.height.equalTo(35)
        }
        pageLabel?.snp.remakeConstraints { (make:ConstraintMaker) in
            make.top.equalTo((nameLabel?.snp.bottom)!).offset(5)
            make.left.equalTo((bookImageView?.snp.right)!).offset(5)
            make.right.equalTo(self).offset(-5)
            make.height.equalTo(35)
        }
        
        addBookButton.snp.remakeConstraints { (make:ConstraintMaker) in
            make.top.equalTo((pageLabel?.snp.bottom)!).offset(5)
            make.left.equalTo((bookImageView?.snp.right)!).offset(5)
            make.height.equalTo(40)
            make.width.equalTo(70)
        }
    }
}
