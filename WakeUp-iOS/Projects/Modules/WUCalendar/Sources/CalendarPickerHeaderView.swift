//
//  CalendarPickerHeaderView.swift
//  WakeUpCalendar
//
//  Created by 강현준 on 2023/09/16.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit

final class CalendarPickerHeaderView: UIView {
    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.text = "Month"
        label.accessibilityTraits = .header
        label.isAccessibilityElement = true
        return label
    }()
    
    private  lazy var leftMonthButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .secondaryLabel
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private  lazy var rightMonthButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .secondaryLabel
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private lazy var dayOfWeekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.label.withAlphaComponent(0.2)
        return view
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM y")
        return dateFormatter
    }()
    
    var baseDate = Date() {
        didSet {
            monthLabel.text = dateFormatter.string(from: baseDate)
        }
    }
    
    private  var leftButtonTappedCompletionHandler: (() -> Void)
    private  var rightButtonTappedCompletionHandler: (() -> Void)
    
    init(
        leftButtonTappedCompletionHandler: @escaping (() -> Void),
        rightButtonTappedCompletionHandler: @escaping (() -> Void)) {
            self.leftButtonTappedCompletionHandler = leftButtonTappedCompletionHandler
            self.rightButtonTappedCompletionHandler = rightButtonTappedCompletionHandler
            
            super.init(frame: .zero)
            
            translatesAutoresizingMaskIntoConstraints = false
            
            backgroundColor = .clear
            
            layer.maskedCorners = [
                .layerMaxXMinYCorner,
                .layerMaxXMinYCorner
            ]
            
            addSubview(monthLabel)
            addSubview(leftMonthButton)
            addSubview(rightMonthButton)
            addSubview(dayOfWeekStackView)
            addSubview(separatorView)
            
            for dayNumber in 1...7 {
                let dayLabel = UILabel()
                dayLabel.font = .systemFont(ofSize: 12, weight: .bold)
                dayLabel.textColor = .secondaryLabel
                dayLabel.textAlignment = .center
                dayLabel.text = dayOfWeekLetter(for: dayNumber)
                
                dayOfWeekStackView.addArrangedSubview(dayLabel)
            }
            
            leftMonthButton.addTarget(self, action: #selector(didTapLeftMonthButton), for: .touchUpInside)
            rightMonthButton.addTarget(self, action: #selector(didTapRightMonthButton), for: .touchUpInside)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapLeftMonthButton() {
        leftButtonTappedCompletionHandler()
    }
    
    @objc func didTapRightMonthButton() {
        rightButtonTappedCompletionHandler()
    }
    
    private func dayOfWeekLetter(for dayNumber: Int) -> String {
        switch dayNumber {
        case 1:
            return "S"
        case 2:
            return "M"
        case 3:
            return "T"
        case 4:
            return "W"
        case 5:
            return "T"
        case 6:
            return "F"
        case 7:
            return "S"
        default:
            return ""
        }
    }
    
    override func layoutSubviews() {
      super.layoutSubviews()

      NSLayoutConstraint.activate([
        
        monthLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
        monthLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        
        leftMonthButton.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor),
        leftMonthButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
        
        rightMonthButton.centerYAnchor.constraint(equalTo: monthLabel.centerYAnchor),
        rightMonthButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

        separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
        separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
        separatorView.heightAnchor.constraint(equalToConstant: 1),
        
        dayOfWeekStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
        dayOfWeekStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        dayOfWeekStackView.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: -5),
      ])
    }
}
