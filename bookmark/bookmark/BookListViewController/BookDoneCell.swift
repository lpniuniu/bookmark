//
//  BookDoneTableViewCell.swift
//  bookmark
//
//  Created by familymrfan on 17/1/11.
//  Copyright © 2017年 niuniu. All rights reserved.
//

import UIKit
import SWTableViewCell
import SnapKit

class BookDoneCell: SWTableViewCell {

    let bookImageView:UIImageView = UIImageView()
    let nameLabel:UILabel = UILabel()
    let doneDateLabel:UILabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(bookImageView)
        addSubview(nameLabel)
        addSubview(doneDateLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bookImageView.snp.remakeConstraints { (make:ConstraintMaker) in
            make.left.top.equalTo(self).offset(5)
            make.bottom.equalTo(self).offset(-25)
            make.width.equalTo(180)
        }
        nameLabel.snp.remakeConstraints { (make:ConstraintMaker) in
            make.top.equalTo(self).offset(5)
            make.left.equalTo(bookImageView.snp.right).offset(5)
            make.right.equalTo(self).offset(-5)
            make.height.equalTo(35)
        }
        doneDateLabel.snp.remakeConstraints { (make:ConstraintMaker) in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(bookImageView.snp.right).offset(5)
            make.right.equalTo(self).offset(-5)
            make.height.equalTo(35)
        }
    }
}
