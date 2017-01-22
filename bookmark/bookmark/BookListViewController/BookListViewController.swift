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
import BTNavigationDropdownMenu

// what she say
class SystemSelectImageSignal: BulbBoolSignal {
    
}

class BookSavedSignal: BulbBoolSignal {
    
}

class BookListViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let noDataLabel:UILabel = UILabel()
    let bookListTable:BookListTableView = BookListTableView()
    let bookDoneListTable:BookDoneListTableView = BookDoneListTableView()
    let pageSlider:BookSlider = BookSlider()
    var alertView:BookAddAlertView?
    let cameraIcon = UIImage(named: "camera")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clouds()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(self.addBook))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action:#selector(self.searchBook))
        navigationController?.navigationBar.tintColor = UIColor.black
        
        tabBarController?.tabBar.barTintColor = UIColor.white
        tabBarController?.tabBar.tintColor = UIColor.black
        let backItem = UIBarButtonItem()
        backItem.title = "返回"
        navigationItem.backBarButtonItem = backItem
        
        installNoDataLabel()
        installBookListTableView()
        installPageSlider()
        installPullDownMenu()
        installBookDoneListTableView()
        
        
        let realm = try! Realm()
        let count = realm.objects(BookData.self).filter("done == false").count
        if (count > 0) {
            bookListTable.isHidden = false
        } else {
            bookListTable.isHidden = true
        }
            
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("\(documentsPath)")
    }
    
    func installNoDataLabel() {
        view.addSubview(noDataLabel)
        noDataLabel.backgroundColor = UIColor.clouds()
        noDataLabel.lineBreakMode = .byWordWrapping
        noDataLabel.numberOfLines = 0
        noDataLabel.text = "您还没有任何阅读的书目，\n通过左上角的🔍或右上角的'+'\n来添加您要阅读的书"
        noDataLabel.font = UIFont.systemFont(ofSize: 18)
        noDataLabel.textAlignment = .center
        noDataLabel.snp.makeConstraints { (maker:ConstraintMaker) in
            maker.left.equalToSuperview().offset(20)
            maker.right.equalToSuperview().offset(-20)
            maker.centerY.equalToSuperview()
            maker.height.equalTo(100)
        }
    }
    
    func installPullDownMenu() {
        let items:[String] = ["阅中", "阅完"]
        let menuView = BTNavigationDropdownMenu(title: items[0], items: items as [AnyObject])
        self.navigationItem.titleView = menuView
        menuView.arrowTintColor = UIColor.greenSea()
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            if indexPath == 0 {
                self?.bookDoneListTable.isHidden = true
            } else {
                self?.bookDoneListTable.reloadData()
                self?.bookDoneListTable.isHidden = false
            }
        }
    }
    
    func searchBook() {
        self.navigationController?.pushViewController(BookSearchViewController(), animated: true)
    }
    
    func changeAlertViewCircleIconView() {
        Bulb.bulbGlobal().register(SystemSelectImageSignal.signalDefault().pickOffFromHungUp(), block: { (firstData:Any?, identifier2Signal:[String : BulbSignal]?) -> Bool in
            guard firstData != nil else {
                return false
            }
            let image:UIImage? = firstData as? UIImage
            let imageView:UIImageView? = self.alertView?.circleIconView as? UIImageView
            imageView?.image = image
            return false
        })
    }
    
    func photoActionSheet() {
        let optionMenu = UIAlertController(title: nil, message: "拍照或选择书的封面", preferredStyle: .actionSheet)
        let taskPhotoAction = UIAlertAction(title: "拍照", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.sourceType = .camera
            picker.delegate = self
            self.alertView?.present(picker, animated: true, completion: {
                self.changeAlertViewCircleIconView()
            })
        })
        let photoLibAction = UIAlertAction(title: "照片库", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            self.alertView?.present(picker, animated: true, completion: {
                self.changeAlertViewCircleIconView()
            })
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        optionMenu.addAction(taskPhotoAction)
        optionMenu.addAction(photoLibAction)
        optionMenu.addAction(cancelAction)
        
        alertView?.present(optionMenu, animated: true, completion: nil)
    }
    
    func addBook() {
        alertView = BookAddAlertView()
        
        alertView?.circleView.bk_(whenTapped: {
            self.photoActionSheet()
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
            if ((imageView?.image) != nil && (imageView?.image) != self.cameraIcon) {
                let data:Data? = UIImagePNGRepresentation((imageView?.image!)!) as Data?
                book.photo = data
            } else {
                let default_img = UIImage(named: "book_default")!
                let data:Data? = UIImagePNGRepresentation(default_img) as Data?
                book.photo = data
            }
            let realm = try! Realm()
            try! realm.write({ 
                realm.add(book)
            })
            Bulb.bulbGlobal().fire(BookSavedSignal.signalDefault(), data: book)
        })
        alertView?.showCustom("请输入书名和页数", subTitle: "", color: UIColor.greenSea(), icon: UIImage())
        
        let imageView:UIImageView? = self.alertView?.circleIconView as? UIImageView
        imageView?.image = cameraIcon
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
            maker.top.equalTo(topLayoutGuide.snp.bottom).offset(10)
            maker.left.equalTo(view).offset(10)
            maker.right.equalTo(view).offset(-10)
            maker.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
        
        weak var weakSelf = self
        Bulb.bulbGlobal().register(BookListDidSelectSignal.signalDefault(), block: { (firstData:Any?, identfier2Signal:[String : BulbSignal]?) -> Bool in
            weakSelf?.bookListTable.snp.remakeConstraints { (maker:ConstraintMaker) in
                maker.top.equalTo((weakSelf?.topLayoutGuide.snp.bottom)!).offset(10)
                maker.left.equalTo((weakSelf?.view)!).offset(10)
                maker.right.equalTo((weakSelf?.view)!).offset(-40)
                maker.bottom.equalTo((weakSelf?.bottomLayoutGuide.snp.top)!)
            }
            UIView.animate(withDuration: 0.3, animations: {
                weakSelf?.bookListTable.layoutIfNeeded()
            })

            return true
        })
        
        Bulb.bulbGlobal().register(BookListDidDeselectSignal.signalDefault(), block: { (firstData:Any?, identfier2Signal:[String : BulbSignal]?) -> Bool in
            
            weakSelf?.bookListTable.snp.remakeConstraints { (maker:ConstraintMaker) in
                maker.top.equalTo((weakSelf?.topLayoutGuide.snp.bottom)!).offset(10)
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
    
    func installBookDoneListTableView() {
        bookDoneListTable.isHidden = true
        bookDoneListTable.backgroundColor = UIColor.white
        view.addSubview(bookDoneListTable)
        bookDoneListTable.snp.makeConstraints { (maker:ConstraintMaker) in
            maker.top.equalTo(topLayoutGuide.snp.bottom)
            maker.left.equalTo(view)
            maker.right.equalTo(view)
            maker.bottom.equalTo(bottomLayoutGuide.snp.top)
        }
    }
    
    func installPageSlider() {
        view.addSubview(pageSlider)
        pageSlider.selectedColor = UIColor.silver()
        pageSlider.chunk.themeColor = UIColor.greenSea()
        pageSlider.unselectColor = UIColor.gray
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

