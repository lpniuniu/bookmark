//
//  BookFeedBackViewController.swift
//  bookmark
//
//  Created by FanFamily on 17/1/21.
//  Copyright © 2017年 niuniu. All rights reserved.
//

import UIKit
import SnapKit
import Crashlytics
import Toast_Swift

class BookFeedBackViewController: UIViewController {

    let textView:UITextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clouds()
        view.addSubview(textView)
        textView.font = UIFont.systemFont(ofSize: 18)
        automaticallyAdjustsScrollViewInsets = false

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .done, target: self, action: #selector(sendFeedBack))
        navigationItem.rightBarButtonItem?.tintColor = view.tintColor
        
        textView.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        textView.snp.remakeConstraints { (maker:ConstraintMaker) in
            maker.left.equalToSuperview().offset(20)
            maker.top.equalTo(topLayoutGuide.snp.bottom).offset(20)
            maker.right.equalToSuperview().offset(-20)
            maker.height.equalTo(200)
        }
    }
    
    func sendFeedBack() {
        let text:String = textView.text
        if text.characters.count > 0 {
            Answers.logCustomEvent(withName: "FeedBack", customAttributes: ["content" : textView.text])
            textView.makeToast("谢谢，收到您的宝贵意见！")
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when, execute: { () in
                _ = self.navigationController?.popViewController(animated: true)
            })
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
