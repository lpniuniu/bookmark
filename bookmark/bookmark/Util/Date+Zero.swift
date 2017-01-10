//
//  File.swift
//  bookmark
//
//  Created by FanFamily on 17/1/11.
//  Copyright © 2017年 niuniu. All rights reserved.
//

import Foundation

extension Date
{
    var zeroOfDate:Date{
        let calendar:Calendar = Calendar.current
        let date = self
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        var components:DateComponents = DateComponents()
        
        components.year = year
        components.month = month
        components.day = day
        components.hour = 8
        components.minute = 0
        components.second = 0
        
        return calendar.date(from: components)!
    }
}
