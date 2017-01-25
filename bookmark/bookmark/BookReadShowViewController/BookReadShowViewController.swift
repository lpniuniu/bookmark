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
import Charts

class BookCalendarChangeMonthSignal: BulbBoolSignal
{
    
}

class ItemAxisValueFormatter : NSObject, IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        switch value {
        case 0:
            return "本月阅读天数"
        case 1:
            return "本月连续阅读天数"
        case 2:
            return "本月读书本数"
        default:
            return ""
        }
    }
}

class ValueAxisValueFormatter : NSObject, IValueFormatter {
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return "\(Int(value))"
    }
}

class BookReadShowViewController: UIViewController {

    let calendarView:JTAppleCalendarView = JTAppleCalendarView()
    let barChartView:BarChartView = BarChartView()
    
    // config
    var numberOfRows = 6
    let formatter = DateFormatter()
    var bookCalendar = Calendar.current
    var generateInDates: InDateCellGeneration = .forAllMonths
    var generateOutDates: OutDateCellGeneration = .tillEndOfGrid
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
        
        view.addSubview(barChartView)


    }
    
    func loadChart() {
        let values = [Double(readDaysCurrentMonth()),  Double(continuousReadBooksCurrentMonth()), Double(readBooksCountCurrentMonth())]
        
        barChartView.chartDescription?.enabled = false
        barChartView.drawBarShadowEnabled = false
        barChartView.highlightFullBarEnabled = false
        barChartView.pinchZoomEnabled = false
        barChartView.leftAxis.enabled = false
        barChartView.rightAxis.enabled = false
        barChartView.drawGridBackgroundEnabled = false
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.granularity = 1.0
        barChartView.xAxis.valueFormatter = ItemAxisValueFormatter()
        
        barChartView.dragEnabled = false
        barChartView.scaleXEnabled = false
        barChartView.scaleYEnabled = false
        barChartView.legend.enabled = false
        
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<3 {
            let entry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(entry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "")
        chartDataSet.valueFormatter = ValueAxisValueFormatter()
        chartDataSet.colors = [UIColor.greenSea(), UIColor.peterRiver(), UIColor.carrot()]
        let chartData = BarChartData(dataSets: [chartDataSet])
        chartData.barWidth = 0.5
        barChartView.data = chartData
        barChartView.notifyDataSetChanged()
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
    
    private func continuousReadBooksCurrentMonth() -> Int {
        var count = 0
        let realm = try! Realm()
        let result = realm.objects(BookReadDateData.self).filter("date >= %@", Date().startMonthOfDate).filter("date <= %@", Date().endMonthOfDate)
        var dateCurrent = Date()
        while dateCurrent >= Date().startMonthOfDate {
            var find = false
            for r in result {
                if r.date == dateCurrent.zeroOfDate {
                    find = true
                    break
                }
            }
            if find == false {
                break
            } else {
                count = count + 1
            }
            dateCurrent = Date(timeInterval: -3600*24, since: dateCurrent)
        }
        return count
    }
    
    private func readDaysCurrentMonth() -> Int {
        let realm = try! Realm()
        return realm.objects(BookReadDateData.self).filter("date >= %@", Date().startMonthOfDate).filter("date <= %@", Date().endMonthOfDate).count
    }
    
    private func readBooksCountCurrentMonth() -> Int {
        let realm = try! Realm()
        return realm.objects(BookReadDoneData.self).filter("doneDate >= %@", Date().startMonthOfDate).filter("doneDate <= %@", Date().endMonthOfDate).count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        calendarView.scrollToDate(Date(), triggerScrollToDateDelegate: false, animateScroll: false)
        
        self.reloadSelectDates()
        
        loadChart()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        calendarView.snp.remakeConstraints { (maker:ConstraintMaker) in
            maker.left.equalToSuperview().offset(10)
            maker.right.equalToSuperview().offset(-10)
            maker.top.equalTo(topLayoutGuide.snp.bottom)
            maker.height.equalTo(300)
        }
        
        barChartView.snp.remakeConstraints { (maker:ConstraintMaker) in
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.top.equalTo(calendarView.snp.bottom).offset(20)
            maker.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-20)
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
                                                 firstDayOfWeek: firstDayOfWeek)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        let cell:BookCalendarCellView = (cell as? BookCalendarCellView)!
        cell.dayLabel.text = cellState.text
        cell.dayLabel.textAlignment = .center
        if cellState.dateBelongsTo == .thisMonth {
            cell.dayLabel.textColor = UIColor.black
        } else {
            cell.dayLabel.textColor = UIColor.lightGray
        }
        
        if selectDates.contains(cellState.date.zeroOfDate) {
            cell.backgroundImage.image  = UIImage(named: "book_2")
        } else {
            cell.backgroundImage.image = nil
        }
        
        if cellState.date.zeroOfDate == Date().zeroOfDate {
            cell.todayImage.image = UIImage(named: "today")
        } else {
            cell.todayImage.image = nil
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
