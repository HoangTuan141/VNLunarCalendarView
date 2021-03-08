//
//  LunarDayCell.swift
//  LunarCalendar
//
//  Created by Hoàng Tuấn on 12/7/20.
//  Copyright © 2020 Hoàng Tuấn. All rights reserved.
//

import UIKit

class LunarDayCell: UICollectionViewCell {
    @IBOutlet private weak var solarDayLabel: UILabel!
    @IBOutlet private weak var lunarDayLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setBorder(width: CGFloat, color: CGColor) {
        self.contentView.layer.borderWidth = width
        self.contentView.layer.borderColor = color
    }
    
    func setBackgroundColor(color: UIColor) {
        self.contentView.backgroundColor = color
    }
    
    func setupCell(day: SolarAndLunarDate, textSolarDayOfCurrentMonthColor: UIColor, textLunarDayOfCurrentMonthColor: UIColor, textSolarDayNotInCurrentMonthColor: UIColor, textLunarDayNotInCurrentMonthColor: UIColor) {
        solarDayLabel.text = "\(day.solarDay)"
        lunarDayLabel.text = "\(day.lunarDay)"
        solarDayLabel.textColor = textSolarDayOfCurrentMonthColor
        lunarDayLabel.textColor = textLunarDayOfCurrentMonthColor
        
        if !day.isDayOfMonth {
            solarDayLabel.textColor = textSolarDayNotInCurrentMonthColor
            lunarDayLabel.textColor = textLunarDayNotInCurrentMonthColor
        }
        
        if day.lunarDay == 1 {
            lunarDayLabel.text = "\(day.lunarDay)/\(day.lunarMonth)"
        }
        
        if day.lunarDay == 1 && day.isDayOfMonth {
            lunarDayLabel.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        }
        
        if day.lunarDay == 1 && !day.isDayOfMonth {
            lunarDayLabel.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.4962542808)
        }
    }
}
