//
//  BookSearchViewController.swift
//  bookmark
//
//  Created by familymrfan on 17/1/6.
//  Copyright © 2017年 niuniu. All rights reserved.
//

import UIKit
import SnapKit

class BookSearchViewController: UIViewController {

    let bookSearchTableView:BookSearchTableView = BookSearchTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        installSearchTableView()
    }
    
    func installSearchTableView() {
        bookSearchTableView.backgroundColor = view.backgroundColor
        view.addSubview(bookSearchTableView)
        bookSearchTableView.snp.makeConstraints { (maker:ConstraintMaker) in
            maker.edges.equalToSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
