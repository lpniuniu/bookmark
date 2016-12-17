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
    let pageSlider:UISlider = BookSlider()
    let pageSliderSp:UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.lightGray
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        installBookListTableView()
        installPageSliderSp()
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
    
    func installPageSliderSp() {
        pageSliderSp.backgroundColor = UIColor.clear
        view.addSubview(pageSliderSp)
        pageSliderSp.snp.makeConstraints { (maker:ConstraintMaker) in
            maker.top.equalTo(topLayoutGuide.snp.bottom).offset(5)
            maker.right.equalTo(view)
            maker.width.equalTo(30)
            maker.bottom.equalTo(view).offset(-5)
        }
    }
    
    func installPageSlider() {
        view.addSubview(pageSlider)
        pageSlider.backgroundColor = UIColor.white
        let trans = CGAffineTransform(rotationAngle: CGFloat(M_PI)/2.0)
        pageSlider.transform = trans;
        pageSlider.snp.makeConstraints { (maker:ConstraintMaker) in
            maker.center.equalTo(pageSliderSp)
            maker.width.equalTo(pageSliderSp.snp.height)
            maker.height.equalTo(pageSliderSp.snp.width)
        }
        pageSlider.configureFlatSlider(withTrackColor: UIColor.silver(), progressColor: UIColor.lightGray, thumbColor: UIColor.greenSea())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

