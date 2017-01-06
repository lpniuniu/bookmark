//
//  BookSearchTableView.swift
//  bookmark
//
//  Created by familymrfan on 17/1/6.
//  Copyright © 2017年 niuniu. All rights reserved.
//

import UIKit
import Alamofire

class BookSearchTableView: UITableView, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    let cellIdentifier:String = "book_search_cellIdentifier"
    let searchBar:UISearchBar = UISearchBar()
    var searchData:NSArray = []
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        delegate = self
        dataSource = self
        
        register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        searchBar.delegate = self
        tableHeaderView = searchBar
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
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
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
                self.searchData = books
                self.reloadData()
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
