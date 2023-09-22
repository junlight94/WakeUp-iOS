//
//  CalendarDateCollectionViewCell.swift
//  WakeUpCalendar
//
//  Created by 강현준 on 2023/09/16.
//  Copyright © 2023 WakeUp. All rights reserved.
//

import UIKit

final class CalendarDateCollectionViewCell: UICollectionViewCell {
    private lazy var selectionBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .systemRed
        
        return view
    }()

    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private lazy var accessibilityDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = .init(identifier: .gregorian)
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMMM d")
        return dateFormatter
    }()
    
    private lazy var markedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = markedColor
        
        return view
    }()
    
    static let reuseIdentifier = String(describing: CalendarDateCollectionViewCell.self)
    
    var day: Day? {
        didSet {
            guard let day = day else { return }
            numberLabel.text = day.number
            accessibilityLabel = accessibilityDateFormatter.string(from: day.date)
            
            updateSelectionStatus()
        }
    }
    
    lazy var marked: Bool = false {
        didSet {
            updateMarkedStatus()
        }
    }
    
    var markedColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        contentView.addSubview(selectionBackgroundView)
        contentView.addSubview(numberLabel)
        contentView.addSubview(markedView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        let size = self.frame.size.width - 20
        
        NSLayoutConstraint.activate([
            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            selectionBackgroundView.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
            selectionBackgroundView.centerXAnchor.constraint(equalTo: numberLabel.centerXAnchor),
            selectionBackgroundView.widthAnchor.constraint(equalToConstant: size),
            selectionBackgroundView.heightAnchor.constraint(equalTo: selectionBackgroundView.widthAnchor),
            
            markedView.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
            markedView.centerXAnchor.constraint(equalTo: numberLabel.centerXAnchor),
            markedView.widthAnchor.constraint(equalToConstant: size),
            markedView.heightAnchor.constraint(equalTo: selectionBackgroundView.widthAnchor)
            
        ])
        
        selectionBackgroundView.layer.cornerRadius = size / 2
        markedView.layer.cornerRadius = size / 2
        
        updateMarkedStatus()
    }
    
}

private extension CalendarDateCollectionViewCell {
    
    func updateSelectionStatus() {
        guard let day = day else { return }
        
        if day.isSelected {
            applySelectedStyle()
        } else {
            applyDefaultStyle(isWithinDisplayedMonth: day.isWithinDisplayedModth)
        }
    }
    
    func applySelectedStyle() {
        numberLabel.textColor = .white
        selectionBackgroundView.backgroundColor = .blue
        selectionBackgroundView.isHidden = false
    }
    
    func applyDefaultStyle(isWithinDisplayedMonth: Bool) {
        numberLabel.textColor = isWithinDisplayedMonth ? .label : .secondaryLabel
        selectionBackgroundView.isHidden = true
    }
    
    func updateMarkedStatus() {
        if marked {
            markedView.isHidden = false
        } else {
            markedView.isHidden = true
        }
    }
    
}




