//  BookReadShowViewController.swift
//  bookmark
//
//  Created by familymrfan on 17/1/9.
//  Copyright © 2017年 niuniu. All rights reserved.
//

import UIKit
import SnapKit
import JTAppleCalendar
import Bulb
import RealmSwift
import BlocksKit

class BookCalendarChangeMonthSignal: BulbBoolSignal
{
    
}

class BookReadShowViewController: UIViewController {

    let calendarView:JTAppleCalendarView = JTAppleCalendarView()
    
    // config
    var numberOfRows = 6
    let formatter = DateFormatter()
    var bookCalendar = Calendar.current
    var generateInDates: InDateCellGeneration = .forAllMonths
    var generateOutDates: OutDateCellGeneration = .tillEndOfGrid
    var hasStrictBoundaries = true
    let firstDayOfWeek: DaysOfWeek = .sunday
    let disabledColor = UIColor.lightGray
    let enabledColor = UIColor.blue
    let dateCellSize: CGFloat? = nil
    
    var selectDates:[Date] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        view.addSubview(calendarView)
        
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.cellInset = CGPoint(x: 0, y: 0)
        
        calendarView.allowsMultipleSelection = true
        calendarView.registerCellViewClass(type: BookCalendarCellView.self)
        calendarView.registerHeaderView(classTypeNames: [BookCalendarHeadView.self])
        calendarView.bk_(whenTapped: {
            self.calendarView.scrollToDate(Date())
        })
    }
    
    func reloadSelectDates() {
        let realm = try! Realm()
        let result = realm.objects(BookReadDateData.self)
        self.selectDates.removeAll()
        for data:BookReadDateData in result {
            self.selectDates.append(data.date!)
        }
        self.calendarView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        calendarView.scrollToDate(Date(), triggerScrollToDateDelegate: false, animateScroll: false)
        
        self.reloadSelectDates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        calendarView.snp.makeConstraints { (maker:ConstraintMaker) in
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.top.equalTo(topLayoutGuide.snp.bottom)
            maker.height.equalTo(300)
        }
    }
}

// MARK: JTAppleCalendarDelegate
extension BookReadShowViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = bookCalendar.timeZone
        formatter.locale = bookCalendar.locale
        
        let startDate = formatter.date(from: "2016 01 01")!
        let endDate = formatter.date(from: "2019 12 01")!
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: numberOfRows,
                                                 calendar: bookCalendar,
                                                 generateInDates: generateInDates,
                                                 generateOutDates: generateOutDates,
                                                 firstDayOfWeek: firstDayOfWeek,
                                                 hasStrictBoundaries: hasStrictBoundaries)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        let cell:BookCalendarCellView = (cell as? BookCalendarCellView)!
        cell.dayLabel.text = cellState.text
        if cellState.dateBelongsTo == .thisMonth {
            cell.dayLabel.textColor = UIColor.black
        } else {
            cell.dayLabel.textColor = UIColor.lightGray
        }
        
        if selectDates.contains(cellState.date.zeroOfDate) {
            cell.backgroundColor = UIColor.greenSea()
        } else {
            cell.backgroundColor = UIColor.white
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, sectionHeaderSizeFor range: (start: Date, end: Date), belongingTo month: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplaySectionHeader header: JTAppleHeaderView, range: (start: Date, end: Date), identifier: String) {
        Bulb.bulbGlobal().fire(BookCalendarChangeMonthSignal.signalDefault(), data: range.start)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {

    }
}
