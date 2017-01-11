//
//  BookSearchTableView.swift
//  bookmark
//
//  Created by familymrfan on 17/1/6.
//  Copyright © 2017年 niuniu. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import Bulb
import RealmSwift
import Toast_Swift

class BookSearchTableView: UITableView, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    let cellIdentifier:String = "book_search_cellIdentifier"
    let searchBar:UISearchBar = UISearchBar()
    var searchData:Array = [NSDictionary]()
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        delegate = self
        dataSource = self
        
        register(BookSearchCell.self, forCellReuseIdentifier: cellIdentifier)
        
        searchBar.delegate = self
        tableHeaderView = searchBar
        
        weak var weakSelf = self
        Bulb.bulbGlobal().register(BookSearchCellAddBookButtonClickSignal.signalDefault()) { (cell:Any?, identifier2Signal:[String:BulbSignal]?) -> Bool in
            
            guard let index:IndexPath = self.indexPath(for: cell as! BookSearchCell) else {
                return false
            }
            let book = weakSelf?.searchData[index.row]
            let newbook = BookData()
            newbook.name = (book?.object(forKey: "title") as? String)!
            newbook.pageTotal = Int((book?.object(forKey: "pages") as? String)!)!
            newbook.photoUrl = book?.object(forKey: "image") as? String
            newbook.serverId = (book?.object(forKey: "id") as? String)!
            
            let realm = try! Realm()
            let result = realm.objects(BookData.self).filter("done == false").filter("serverId == '\(newbook.serverId)'")
            if result.count == 0 {
                try! realm.write {
                    realm.add(newbook)
                }
                Bulb.bulbGlobal().fire(BookSavedSignal.signalDefault(), data: newbook)
            }
            (cell as! BookSearchCell).makeToast("\(newbook.name)已加入阅读列表")
            return true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        searchBar.frame = CGRect(x: 0, y: 0, width: frame.width, height: 40)
    }
    
    // MARK: tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BookSearchCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BookSearchCell
        
        
        let book = searchData[indexPath.row]
        let url = URL(string: book.object(forKey: "image") as! String)
        cell.bookImageView.kf.setImage(with: url)
        cell.nameLabel.text = book.object(forKey: "title") as? String
        cell.pageLabel.text = book.object(forKey: "pages") as? String
        cell.addBookButton.bk_(whenTapped: {
            Bulb.bulbGlobal().fire(BookSearchCellAddBookButtonClickSignal.signalDefault(), data: cell)
        })
        return cell
    }
    
    // MARK: search bar delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("\(searchBar.text)")
        if let searchText = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            Alamofire.request("https://api.douban.com/v2/book/search?q=\(searchText)").responseJSON { (response:DataResponse<Any>) in
                print("\(response.result)")
                guard response.result.isSuccess else {
                    return
                }
                guard let json = response.result.value as? NSDictionary else {
                    return
                }
                guard let books = json.object(forKey: "books") as? NSArray else {
                    return
                }
                
                self.searchData.removeAll()
                for book in books {
                    guard let book = book as? NSDictionary else {
                        continue
                    }
                    guard let bookName = book.object(forKey: "title") as! String?, bookName != "" else {
                        continue
                    }
                    guard let bookPage = book.object(forKey: "pages") as! String?, bookPage != ""  else {
                        continue
                    }
                    guard let bookImage = book.object(forKey: "image") as! String?, bookImage != ""  else {
                        continue
                    }
                    guard let bookId = book.object(forKey: "id") as! String?, bookId != ""  else {
                        continue
                    }
                    self.searchData.append(book)
                }
                self.reloadData()
                self.endEditing(true)
            }
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
