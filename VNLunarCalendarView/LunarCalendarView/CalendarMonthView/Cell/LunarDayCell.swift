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
        setBorder(width: 0.5, color: #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1))
    }
    
    func setBorder(width: CGFloat, color: CGColor) {
        self.contentView.layer.borderWidth = width
        self.contentView.layer.borderColor = color
    }
    
    func setupCell(day: SolarAndLunarDate) {
        solarDayLabel.text = "\(day.solarDay)"
        lunarDayLabel.text = "\(day.lunarDay)"
        if !day.isDayOfMonth {
            solarDayLabel.textColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
            lunarDayLabel.textColor = #colorLiteral(red: 1, green: 0.8078431373, blue: 0.6274509804, alpha: 1)
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
