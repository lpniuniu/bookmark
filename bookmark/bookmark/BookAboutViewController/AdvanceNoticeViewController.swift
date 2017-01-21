//
//  ThanksViewController.swift
//  bookmark
//
//  Created by familymrfan on 17/1/20.
//  Copyright © 2017年 niuniu. All rights reserved.
//

import UIKit
import SnapKit

class AdvanceNoticeViewController: UIViewController {

    let textView:UITextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        let path = Bundle.main.path(forResource: "an", ofType: "txt")
        let text = try! String(contentsOfFile: path!, encoding: .utf8)
        textView.text = text
        textView.isEditable = false
        view.addSubview(textView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        textView.snp.remakeConstraints { (maker:ConstraintMaker) in
            maker.edges.equalToSuperview()
        }
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
