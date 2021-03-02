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
    }


}

extension ViewController: VNLunarCalendarViewDelegate {
    func dateDidSelect(_ date: SolarAndLunarDate) {
        print("Date did select is: \(date)")
        lunarCalendarView.setCurrentlySelectedDate(date.solarDay, date.solarMonth, date.solarYear)
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
