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
import Bulb
import SCLAlertView
import BlocksKit
import RealmSwift

// what she say
class SystemSelectImageSignal: BulbBoolSignal {
    
}

class BookSavedSignal: BulbBoolSignal {
    
}

class BookListViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let bookListTable:BookListTableView = BookListTableView()
    let pageSlider:BookSlider = BookSlider()
    var alertView:BookAddAlertView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.lightGray
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(self.addBook))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action:#selector(self.searchBook))
        installBookListTableView()
        installPageSlider()
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("\(documentsPath)")
    }
    
    func searchBook() {
        self.navigationController?.pushViewController(BookSearchViewController(), animated: true)
    }
    
    func addBook() {
        alertView = BookAddAlertView()
        alertView?.circleView.bk_(whenTapped: {
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            self.alertView?.present(picker, animated: true, completion: {
                Bulb.bulbGlobal().register(SystemSelectImageSignal.signalDefault().pickOffFromHungUp(), block: { (firstData:Any?, identifier2Signal:[String : BulbSignal]?) in
                    let image:UIImage? = firstData as? UIImage
                    let imageView:UIImageView? = self.alertView?.circleIconView as? UIImageView
                    imageView?.image = image
                })
            })
        })
        alertView?.closeView.bk_(whenTapped: { 
            self.alertView?.hideView()
        })
        let bookNameTextField = alertView?.addTextField()
        let pageTextField = alertView?.addTextField()
        pageTextField?.keyboardType = .numberPad
        alertView?.addButton("确认", action: { 
            let imageView:UIImageView? = self.alertView?.circleIconView as? UIImageView
            let book = BookData()
            book.name = (bookNameTextField?.text)!
            book.pageTotal = Int((pageTextField?.text)!)!
            if ((imageView?.image) != nil) {
                let data:Data? = UIImagePNGRepresentation((imageView?.image!)!) as Data?
                book.photo = data
            }
            let realm = try! Realm()
            try! realm.write({ 
                realm.add(book)
            })
            Bulb.bulbGlobal().fire(BookSavedSignal.signalDefault(), data: book)
        })
        alertView?.showCustom("请输入书名和页数", subTitle: "", color: UIColor.greenSea(), icon: UIImage())
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image:UIImage = (info[UIImagePickerControllerEditedImage] as? UIImage)!
        picker.dismiss(animated: true, completion: {
            Bulb.bulbGlobal().hungUpAndFire(SystemSelectImageSignal.signalDefault(), data: image)
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func installBookListTableView() {
        bookListTable.backgroundColor = view.backgroundColor
        view.addSubview(bookListTable)
        bookListTable.snp.makeConstraints { (maker:ConstraintMaker) in
            maker.top.equalTo(view).offset(10)
            maker.left.equalTo(view).offset(10)
            maker.right.equalTo(view).offset(-10)
            maker.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
        
        weak var weakSelf = self
        Bulb.bulbGlobal().register(BookListDidSelectSignal.signalDefault(), foreverblock: { (firstData:Any?, identfier2Signal:[String : BulbSignal]?) -> Bool in
            weakSelf?.bookListTable.snp.remakeConstraints { (maker:ConstraintMaker) in
                maker.top.equalTo((weakSelf?.view)!).offset(10)
                maker.left.equalTo((weakSelf?.view)!).offset(10)
                maker.right.equalTo((weakSelf?.view)!).offset(-40)
                maker.bottom.equalTo((weakSelf?.bottomLayoutGuide.snp.top)!)
            }
            UIView.animate(withDuration: 0.3, animations: {
                weakSelf?.bookListTable.layoutIfNeeded()
            })

            return true
        })
        
        Bulb.bulbGlobal().register(BookListDidDeselectSignal.signalDefault(), foreverblock: { (firstData:Any?, identfier2Signal:[String : BulbSignal]?) -> Bool in
            
            weakSelf?.bookListTable.snp.remakeConstraints { (maker:ConstraintMaker) in
                maker.top.equalTo((weakSelf?.view)!).offset(10)
                maker.left.equalTo((weakSelf?.view)!).offset(10)
                maker.right.equalTo((weakSelf?.view)!).offset(-10)
                maker.bottom.equalTo((weakSelf?.bottomLayoutGuide.snp.top)!)
            }
            UIView.animate(withDuration: 0.3, animations: {
                
                weakSelf?.bookListTable.layoutIfNeeded()
            })
            return true
        })
    }
    
    func installPageSlider() {
        view.addSubview(pageSlider)
        pageSlider.selectedColor = UIColor.silver()
        pageSlider.chunk.themeColor = UIColor.greenSea()
        pageSlider.unselectColor = UIColor.black
        pageSlider.hideSlider()
        pageSlider.backgroundColor = UIColor.clouds()
        pageSlider.snp.makeConstraints { (maker:ConstraintMaker) in
            maker.top.equalTo(topLayoutGuide.snp.bottom)
            maker.right.equalTo(view)
            maker.width.equalTo(30)
            maker.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

