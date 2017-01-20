//
//  BookCalendarCellView.swift
//  bookmark
//
//  Created by familymrfan on 17/1/10.
//  Copyright © 2017年 niuniu. All rights reserved.
//

import UIKit
import SnapKit
import JTAppleCalendar

class BookCalendarCellView: JTAppleDayCellView {

    let backgroundImage:UIImageView = UIImageView()
    let dayLabel:UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backgroundImage)
        backgroundImage.alpha = 0.6
        addSubview(dayLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundImage.snp.remakeConstraints { (maker:ConstraintMaker) in
            maker.left.equalToSuperview().offset(12)
            maker.right.equalToSuperview().offset(-12)
            maker.top.bottom.equalToSuperview()
        }
        
        dayLabel.snp.remakeConstraints { (maker:ConstraintMaker) in
            maker.edges.equalToSuperview()
        }
    }

    
}
