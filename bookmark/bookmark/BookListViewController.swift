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

class BookListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellIdentifier:String = "cellIdentifier"
    let tableView:UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
        view.addSubview(tableView)
        tableView.backgroundColor = view.backgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { (maker:ConstraintMaker) in
            maker.top.equalTo(view).offset(10)
            maker.left.equalTo(view).offset(10)
            maker.right.equalTo(view).offset(-10)
            maker.bottom.equalTo(view)
        }
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.showsVerticalScrollIndicator = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.configureFlatCell(with: UIColor.clouds(), selectedColor: UIColor.greenSea(), roundingCorners:.allCorners)
        cell.cornerRadius = 5.0
        cell.separatorHeight = 20.0
        cell.backgroundColor = view.backgroundColor
        
        return cell
    }
}

