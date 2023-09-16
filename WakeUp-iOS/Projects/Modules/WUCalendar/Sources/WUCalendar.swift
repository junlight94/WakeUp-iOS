//
//  WUCalendar.swift
//  WUCalendar
//
//  Created by 강현준 on 2023/09/15.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit

public class WUCalendar: UIView {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = backgroundColor

        return collectionView
    }()
    
    private lazy var headerView = CalendarPickerHeaderView(leftButtonTappedCompletionHandler: { [weak self] in
        guard let self = self else { return }
        
        self.baseDate = self.calendar.date(byAdding: .month, value: -1, to: self.baseDate) ?? self.baseDate
        
    }, rightButtonTappedCompletionHandler: { [weak self] in
        guard let self = self else { return }
        
        self.baseDate = self.calendar.date(byAdding: .month, value: 1, to: self.baseDate) ?? self.baseDate
        
    })
    
    private let calendar = Calendar(identifier: .gregorian)
    
    public var headerViewHeight: CGFloat = 80
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter
    }()
    
    private var baseDate: Date {
        didSet {
            days = generateDaysInMonth(for: baseDate)
            collectionView.reloadData()
            headerView.baseDate = baseDate
        }
    }
    
    private lazy var days: [Day] = generateDaysInMonth(for: baseDate)
    
    private let selectedDateChanged: ((Date) -> Void)
    
    private var numberOfWeeksInBaseDate: Int {
        calendar.range(of: .weekOfMonth, in: .month, for: baseDate)?.count ?? 0
    }
    
    public override var backgroundColor: UIColor? {
        didSet {
            collectionView.backgroundColor = backgroundColor
        }
    }
    
    public init(baseDate: Date, selectedDateChanged: @escaping ((Date) -> Void)) {
        self.baseDate = baseDate
        self.selectedDateChanged = selectedDateChanged
        super.init(frame: .zero)
        
        layout()
        setDelegate()
        
        headerView.baseDate = baseDate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        layout()
    }
    
    func layout() {
        self.addSubview(collectionView)
        self.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: headerViewHeight),
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: frame.height - headerViewHeight)
        ])
    }
    
    func setDelegate() {
        collectionView.register(CalendarDateCollectionViewCell.self, forCellWithReuseIdentifier: CalendarDateCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

private extension WUCalendar {
    
    func monthMetaData(for baseDate: Date) throws -> MonthMetadata {
        /// 1. 한 달에 몇 일이 있는지
        guard let numberOfDaysInMonth = calendar.range(
            of: .day,
            in: .month,
            for: baseDate)?.count,
                                /// 3. 2에서 추출한 년도와 월의 컴포넌트를 바탕으로 실제 Date객체를 생성, day가 지정되지 않았으므로 해당 월의 1일을 가리키게됨.
              let firstDayOfMonth = calendar.date(
                        /// 2. baseDate가 2023년 5월 15일이라면 2023년 5월 만을 가리키는 컴포넌트를 반환
                from: calendar.dateComponents([.year, .month], from: baseDate)
              )
        else {
            throw CalendarDataError.metadataGeneration
        }
                            /// .weekday는 요일을 나타내는 컴포넌트 일요일은 1, 월요일은 2... 로 표현됨 즉 해당 firstDayOfMonth가 무슨 요일인지를 가져옴
        let firstDayWeekDay = calendar.component(.weekday, from: firstDayOfMonth)
        
        return MonthMetadata(
            numberOfDays: numberOfDaysInMonth,  
            firstDay: firstDayOfMonth,           
            firstDayWeekDay: firstDayWeekDay    
        )
    }
    
    /// 해당하는 월의 모든날을 나타내는 [Day]를 생성함. (전 달 포함)
    func generateDaysInMonth(for baseDate: Date) -> [Day] {
        guard let metadata = try? monthMetaData(for: baseDate) else {
            fatalError("An error occurred when generating the metadata for \(baseDate)")
        }
        
        let numberOfDaysInMonth = metadata.numberOfDays
        let offsetInInitialRow = metadata.firstDayWeekDay   // 월의 첫 날이 해당 주에 무슨요일인지를 나타냄
        let firstDayOfMonth = metadata.firstDay
        
        var days: [Day] = (1..<(numberOfDaysInMonth + offsetInInitialRow))
            .map { day in
                let isWithinDisplayedMonth = day >= offsetInInitialRow
                let dayOffset = isWithinDisplayedMonth ?
                day - offsetInInitialRow : -(offsetInInitialRow - day)
                
                return generateDay(
                        offsetBy: dayOffset,
                        for: firstDayOfMonth,
                        isWithinDisplayedMonth: isWithinDisplayedMonth)
            }
        
        days += generateStartOfNextMont(using: firstDayOfMonth)
        
        return days
    }
    
    /// 해당 월의 마지막이 비어있다면 다음달 Day를 추가해야함
    func generateStartOfNextMont(
        using firstDayOfDisplayedMonth: Date) -> [Day] {
            
            // 해당 월의 마지막 날짜
            guard let lastDayInMonth = calendar.date(
                byAdding: DateComponents(month: 1, day: -1),
                to: firstDayOfDisplayedMonth
            ) else {
                return []
            }
            
            
            let additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
            
            guard additionalDays > 0 else {
                return []
            }
            
            let days: [Day] = (1...additionalDays)
                .map {
                    generateDay(
                        offsetBy: $0,
                        for: lastDayInMonth,
                        isWithinDisplayedMonth: false
                        )
                }
            
            return days
        }
    
    
    func generateDay(
      offsetBy dayOffset: Int,
      for baseDate: Date,
      isWithinDisplayedMonth: Bool
    ) -> Day {
        let date = calendar.date(
            byAdding: .day,
            value: dayOffset,
            to: baseDate) ?? baseDate
        
        return Day(
            date: date,
            number: dateFormatter.string(from: date),
            isSelected: false,
            isWithinDisplayedModth: isWithinDisplayedMonth,
            isJoined: 0
        )
    }
}

extension WUCalendar: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let day = days[indexPath.row]
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarDateCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? CalendarDateCollectionViewCell else { return UICollectionViewCell() }
        
        cell.day = day
        
        return cell
    }
}

extension WUCalendar: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        days = days.map { day -> Day in
            var modifiedDay = day
            modifiedDay.isSelected = false
            return modifiedDay
        }
        
        days[indexPath.row].isSelected.toggle()
        
        collectionView.reloadData()
        
//        var day = days[indexPath.row]
//        selectedDateChanged(day.date)
        
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int(collectionView.frame.width / 7)
        let height = Int(collectionView.frame.height) / numberOfWeeksInBaseDate
        
        return CGSize(width: width, height: height)
    }
}
