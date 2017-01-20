//
//  BookAboutViewController.swift
//  bookmark
//
//  Created by familymrfan on 17/1/20.
//  Copyright © 2017年 niuniu. All rights reserved.
//

import UIKit
import SnapKit
import BlocksKit

class BookAboutViewController: UIViewController {
    
    let logoImage:UIImageView = UIImageView()
    let nameLabel:UILabel = UILabel()
    let versionLabel:UILabel = UILabel()
    let version:String = "v1.0"
    let advanceNoticeBtn:UIButton = UIButton(type: .system)
    let thanksBtn:UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        
        title = "关于"
        
        view.addSubview(logoImage)
        logoImage.image = UIImage(named: "logo")
        logoImage.snp.makeConstraints { (maker:ConstraintMaker) in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().offset(-150)
            maker.width.height.equalTo(180)
        }
        
        nameLabel.text = "三味书签"
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont(name: "Helvetica-Bold", size: 24)
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (maker:ConstraintMaker) in
            maker.top.equalTo(logoImage.snp.bottom).offset(10)
            maker.centerX.equalToSuperview()
            maker.left.right.equalToSuperview()
            maker.height.equalTo(30)
        }
        
        versionLabel.text = version
        versionLabel.textAlignment = .center
        view.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { (maker:ConstraintMaker) in
            maker.top.equalTo(nameLabel.snp.bottom).offset(10)
            maker.centerX.equalToSuperview()
            maker.left.right.equalToSuperview()
            maker.height.equalTo(30)
        }
        
        advanceNoticeBtn.setTitle("下期功能预告", for: .normal)
        view.addSubview(advanceNoticeBtn)
        advanceNoticeBtn.snp.makeConstraints { (maker:ConstraintMaker) in
            maker.top.equalTo(versionLabel.snp.bottom).offset(10)
            maker.centerX.equalToSuperview()
            maker.left.right.equalToSuperview()
            maker.height.equalTo(30)
        }
        
        advanceNoticeBtn.bk_(whenTapped: { () in
            self.navigationController?.pushViewController(AdvanceNoticeViewController(), animated: true)
        })
        
        thanksBtn.setTitle("致谢", for: .normal)
        view.addSubview(thanksBtn)
        thanksBtn.snp.makeConstraints { (maker:ConstraintMaker) in
            maker.top.equalTo(advanceNoticeBtn.snp.bottom).offset(10)
            maker.centerX.equalToSuperview()
            maker.left.right.equalToSuperview()
            maker.height.equalTo(30)
        }
        
        thanksBtn.bk_(whenTapped: { () in
            self.navigationController?.pushViewController(ThanksViewController(), animated: true)
        })
    }
}
