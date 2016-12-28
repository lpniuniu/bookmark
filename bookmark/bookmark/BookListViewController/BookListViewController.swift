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
    let pageSlider:UISlider = BookSlider()
    let pageSliderSp:UIView = UIView()
    var alertView:BookAddAlertView?
    var bulb:Bulb = Bulb.bulbGlobal()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.lightGray
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(self.addBook))
        installBookListTableView()
        installPageSliderSp()
        installPageSlider()
    }
    
    func addBook() {
        
        
        // Bulb.bulbGlobal().fire(AddBookSignal(), data: nil
        alertView = BookAddAlertView()
        alertView?.circleView.bk_(whenTapped: {
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            self.alertView?.present(picker, animated: true, completion: {
                Bulb.bulbGlobal().register(SystemSelectImageSignal().on().pickOffFromHungUp(), block: { (firstData:Any?, identifier2Signal:[String : BulbSignal]?) in
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
            Bulb.bulbGlobal().fire(BookSavedSignal().on(), data: book)
        })
        alertView?.showCustom("请输入书名和页数", subTitle: "", color: UIColor.greenSea(), icon: UIImage())
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image:UIImage = (info[UIImagePickerControllerEditedImage] as? UIImage)!
        picker.dismiss(animated: true, completion: {
            Bulb.bulbGlobal().hungUpAndFire(SystemSelectImageSignal().on(), data: image)
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
        pageSlider.alpha = 0
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

