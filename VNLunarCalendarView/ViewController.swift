//
//  ViewController.swift
//  VNLunarCalendarView
//
//  Created by Hoàng Tuấn on 02/03/2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var heightOfLunarCalendarViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var lunarCalendarView: VNLunarCalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lunarCalendarView.delegate = self
        lunarCalendarView.setCurrentMonth(month: 2, year: 2021)
        lunarCalendarView.setWeekdayTitle(weekdayTitle: ["T2", "T3", "T4", "T5", "T6", "T7", "CN"])
        lunarCalendarView.setBackgroundColor(.red)
        lunarCalendarView.setBackgroundCurrentDay(.blue)
        lunarCalendarView.setBackgroundDateSelectedColor(.yellow)
        lunarCalendarView.setBorderColorDay(color: .gray, borderWidth: 0.5)
        lunarCalendarView.setBorderColorDaySelected(color: .orange, borderWidth: 5)
        lunarCalendarView.setHeightOfDayView(height: 50)
        lunarCalendarView.setWeekdayTitleColor(color: .black)
        lunarCalendarView.setTextDayColor(textSolarDayOfCurrentMonthColor: .black, textLunarDayOfCurrentMonthColor: .gray, textSolarDayNotInCurrentMonthColor: .green, textLunarDayNotInCurrentMonthColor: .blue)
    }


}

extension ViewController: VNLunarCalendarViewDelegate {
    func dateDidSelect(_ solarDay: Int, _ solarMonth: Int, _ solarYear: Int, _ lunarDay: Int, _ lunarMonth: Int, _ lunarYear: Int) {
        lunarCalendarView.setCurrentlySelectedDate(solarDay, solarMonth, solarYear)
    }
    
    func monthAndYearIsShowing(_ month: Int, _ year: Int) {
        print("Month and year is showing: \(month)/\(year)")
    }
    
    func numberOfRowInCalendarView(_ row: Int) {
        switch row {
        case 4:
            self.heightOfLunarCalendarViewConstraint.constant = 231
        case 5:
            self.heightOfLunarCalendarViewConstraint.constant = 281
        case 6:
            self.heightOfLunarCalendarViewConstraint.constant = 331
        default:
            return
        }
    }
    
    
}
