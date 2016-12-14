//
//  ViewController.swift
//  bookmark
//
//  Created by FanFamily on 2016/12/13.
//  Copyright © 2016年 niuniu. All rights reserved.
//

import UIKit
import FlatUIKit
import SnapKit

class BookListViewController: UIViewController {
    
    
    let bookListTable:BookListTableView = BookListTableView()
    let pageSlider:UISlider = UISlider()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.lightGray
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        installBookListTableView()
        installPageSlider()
    }
    
    func installBookListTableView() {
        bookListTable.backgroundColor = view.backgroundColor
        view.addSubview(bookListTable)
        bookListTable.snp.makeConstraints { (maker:ConstraintMaker) in
            maker.top.equalTo(view).offset(10)
            maker.left.equalTo(view).offset(10)
            maker.right.equalTo(view).offset(-10)
            maker.bottom.equalTo(view)
        }
    }
    
    func installPageSlider() {
        bookListTable.addSubview(pageSlider)
        pageSlider.backgroundColor = UIColor.white
        let trans = CGAffineTransform(rotationAngle: CGFloat(M_PI)/2.0)
        pageSlider.transform = trans;
        pageSlider.snp.makeConstraints { (maker:ConstraintMaker) in
            maker.centerY.equalTo(bookListTable.subviews[0].snp.centerY)
            maker.centerX.equalTo(view.snp.right).offset(-15)
            maker.width.equalTo(657)
            maker.height.equalTo(30)
        }
        pageSlider.configureFlatSlider(withTrackColor: UIColor.silver(), progressColor: UIColor.alizarin(), thumbColor: UIColor.greenSea())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

