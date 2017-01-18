//
//  BookCell.swift
//  bookmark
//
//  Created by familymrfan on 16/12/28.
//  Copyright © 2016年 niuniu. All rights reserved.
//

import UIKit
import SWTableViewCell
import SnapKit

class BookCell: SWTableViewCell {
    
    let bookImageView:UIImageView = UIImageView()
    let nameLabel:UILabel = UILabel()
    let pageLabel:UILabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(bookImageView)
        addSubview(nameLabel)
        addSubview(pageLabel)
        
        build()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bookImageView.snp.remakeConstraints { (make:ConstraintMaker) in
            make.left.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-25)
            make.width.equalTo(150)
        }
        nameLabel.snp.remakeConstraints { (make:ConstraintMaker) in
            make.top.equalToSuperview().offset(5)
            make.left.equalTo(bookImageView.snp.right).offset(5)
            make.right.equalToSuperview().offset(-5)
            make.height.equalTo(35)
        }
        pageLabel.snp.remakeConstraints { (make:ConstraintMaker) in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(bookImageView.snp.right).offset(5)
            make.right.equalToSuperview().offset(-5)
            make.height.equalTo(35)
        }
    }
}
