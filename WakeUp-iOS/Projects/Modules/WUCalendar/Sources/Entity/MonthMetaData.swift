//
//  MonthMetaData.swift
//  WakeUpCalendar
//
//  Created by 강현준 on 2023/09/15.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import Foundation

struct MonthMetadata {
    let numberOfDays: Int // 해당 달이 총 몇일인지
    let firstDay: Date  // 해당 월의 1일의 Date
    let firstDayWeekDay: Int  // 첫 번째 날짜가 무슨 요일인지. (일요일이 1)
}
