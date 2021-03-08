//
//  LunarCalendarView.swift
//  VNLunarCalendarView
//
//  Created by Hoàng Tuấn on 02/03/2021.
//

import Foundation
import UIKit

public protocol VNLunarCalendarViewDelegate: class {
    func dateDidSelect(_ solarDay: Int, _ solarMonth: Int, _ solarYear: Int, _ lunarDay: Int, _ lunarMonth: Int, _ lunarYear: Int)
    func monthAndYearIsShowing(_ month: Int, _ year: Int)
    func numberOfRowInCalendarView(_ row: Int)
}

open class VNLunarCalendarView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet private weak var weekdayView: UIView!
    @IBOutlet private var weekdayLabel: [UILabel]!
    @IBOutlet weak var scrollView: UIScrollView!
    private var listMonth = [[SolarAndLunarDate]]()
    
    open weak var delegate: VNLunarCalendarViewDelegate?
    
    private var currentlySelectedDate: SolarAndLunarDate?
    private var currentMonth: MonthYear = MonthYear(month: Date().month, year: Date().year) {
        didSet {
            let currentMonth = self.currentMonth.month
            let currentYear = self.currentMonth.year
            self.delegate?.monthAndYearIsShowing(currentMonth, currentYear)
            let previousMonth = getPreviousMonth(currentMonth: currentMonth, currentYear: currentYear)[0]
            let yearOfPreviousMonth = getPreviousMonth(currentMonth: currentMonth, currentYear: currentYear)[1]
            
            let nextMonth = getNextMonth(currentMonth: currentMonth, currentYear: currentYear)[0]
            let yearOfNextMonth = getNextMonth(currentMonth: currentMonth, currentYear: currentYear)[1]
            
            let list = [createArrayDayOfMonth(month: previousMonth, year: yearOfPreviousMonth),
                        createArrayDayOfMonth(month: currentMonth, year: currentYear),
                        createArrayDayOfMonth(month: nextMonth, year: yearOfNextMonth),
                        ]
            
            self.delegate?.numberOfRowInCalendarView(list[1].count/7)
            listMonth.removeAll()
            listMonth = list
            slides = createSlides()
            setupSlideScrollView(slides: slides)
            scrollView.delegate = self
            scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.width, y: 0), animated: false)
        }
    }
    
    var currentIndex = 1
    var slides = [LunarMonthView]()
    var backgroundCurrentDay = #colorLiteral(red: 0.9843137255, green: 0.8745098039, blue: 0.7647058824, alpha: 1)
    var backgroundDateSelectedColor = UIColor.clear
    var borderColorDay = UIColor.clear
    var borderWidthDay: CGFloat = 0
    var borderColorDaySelected = UIColor.clear
    var borderWidthDaySelected: CGFloat = 0
    var heightOfDayView: CGFloat = 50
    var textSolarDayOfCurrentMonthColor = UIColor.black
    var textLunarDayOfCurrentMonthColor = #colorLiteral(red: 0.9803921569, green: 0.5725490196, blue: 0.2, alpha: 1)
    var textSolarDayNotInCurrentMonthColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
    var textLunarDayNotInCurrentMonthColor = #colorLiteral(red: 1, green: 0.8078431373, blue: 0.6274509804, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        let bundleIdentifier = "org.cocoapods.VNLunarCalendarView"
        guard let bundle = Bundle(identifier: bundleIdentifier) else {
            fatalError("Can not find bundle with name: \(bundleIdentifier)")
        }
        bundle.loadNibNamed("VNLunarCalendarView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        viewDidLoad()
    }
    
    private func viewDidLoad() {
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        scrollView.delegate = self
        scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.width, y: 0), animated: false)
    }
}

// MARK: - Setup Calendar View
extension VNLunarCalendarView {
    public func setCurrentMonth(month: Int, year: Int) {
        self.currentMonth = MonthYear(month: month, year: year)
    }
    
    public func setCurrentlySelectedDate(_ solarDay: Int, _ solarMonth: Int, _ solarYear: Int) {
        let lunarDateArr = self.convertSolar2Lunar(dd: solarDay, mm: solarMonth, yy: solarYear, timeZone: 7)
        guard lunarDateArr.count == 4 else { return }
        self.currentlySelectedDate = SolarAndLunarDate(solarDay: solarDay, solarMonth: solarMonth, solarYear: solarYear, isDayOfMonth: true, lunarDay: lunarDateArr[0], lunarMonth: lunarDateArr[1], lunarYear: lunarDateArr[2])
    }
    
    public func setWeekdayTitle(weekdayTitle: [String]) {
        guard weekdayTitle.count == 7 else { return }
        for i in 0..<weekdayTitle.count {
            weekdayLabel[i].text = weekdayTitle[i]
        }
    }
    
    public func setWeekdayTitleColor(color: UIColor) {
        for i in weekdayLabel{
            i.textColor = color
        }
    }
    
    public func setBackgroundColor(_ color: UIColor) {
        self.contentView.backgroundColor = color
    }
    
    public func setBackgroundCurrentDay(_ color: UIColor) {
        self.backgroundCurrentDay = color
    }
    
    public func setBackgroundDateSelectedColor(_ color: UIColor) {
        self.backgroundDateSelectedColor = color
    }
    
    public func setBorderColorDay(color: UIColor, borderWidth: CGFloat) {
        self.borderColorDay = color
        self.borderWidthDay = borderWidth
    }
    
    public func setBorderColorDaySelected(color: UIColor, borderWidth: CGFloat) {
        self.borderColorDaySelected = color
        self.borderWidthDaySelected = borderWidth
    }
    
    public func setHeightOfDayView(height: CGFloat) {
        self.heightOfDayView = height
    }
    
    public func setTextDayColor(textSolarDayOfCurrentMonthColor: UIColor, textLunarDayOfCurrentMonthColor: UIColor, textSolarDayNotInCurrentMonthColor: UIColor, textLunarDayNotInCurrentMonthColor: UIColor) {
        self.textSolarDayOfCurrentMonthColor = textSolarDayOfCurrentMonthColor
        self.textLunarDayOfCurrentMonthColor = textLunarDayOfCurrentMonthColor
        self.textSolarDayNotInCurrentMonthColor = textSolarDayNotInCurrentMonthColor
        self.textLunarDayNotInCurrentMonthColor = textLunarDayNotInCurrentMonthColor
    }
}

// MARK: - ScrollView Delegate
extension VNLunarCalendarView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
                scrollView.contentOffset.y = 0
            }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(scrollView.contentOffset.x / contentView.frame.width))
        let month = currentMonth.month
        let year = currentMonth.year
        if pageIndex < currentIndex {
            let monthAndYearPrevious = self.getPreviousMonth(currentMonth: month, currentYear: year)
            self.currentMonth = MonthYear(month: monthAndYearPrevious[0], year: monthAndYearPrevious[1])
        } else if pageIndex > currentIndex {
            let monthAndYearNext = self.getNextMonth(currentMonth: month, currentYear: year)
            self.currentMonth = MonthYear(month: monthAndYearNext[0], year: monthAndYearNext[1])
        }
    }
}

// MARK: - Setup Slide ScrollView
extension VNLunarCalendarView {
    func createSlides() -> [LunarMonthView] {
        guard listMonth.count == 3 else { return [LunarMonthView]()}
        var list = [LunarMonthView]()
        for i in 0 ... 2 {
            let slide = LunarMonthView()
            slide.listDay = listMonth[i]
            slide.backgroundCurrentDay = self.backgroundCurrentDay
            slide.backgroundDateSelectedColor = self.backgroundDateSelectedColor
            slide.borderColorDay = self.borderColorDay
            slide.borderWidthDay = self.borderWidthDay
            slide.borderColorDaySelected = self.borderColorDaySelected
            slide.borderWidthDaySelected = self.borderWidthDaySelected
            slide.height = self.heightOfDayView
            slide.textSolarDayOfCurrentMonthColor = self.textSolarDayOfCurrentMonthColor
            slide.textLunarDayOfCurrentMonthColor = self.textLunarDayOfCurrentMonthColor
            slide.textSolarDayNotInCurrentMonthColor = self.textSolarDayNotInCurrentMonthColor
            slide.textLunarDayNotInCurrentMonthColor = self.textLunarDayNotInCurrentMonthColor
            
            if let date = self.currentlySelectedDate {
                slide.dateSelected = date
            }
            list.append(slide)
        }
        return list
    }
    
    func setupSlideScrollView(slides : [LunarMonthView]) {
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        scrollView.isPagingEnabled = true
        scrollView.frame = CGRect(x: 0, y: 30, width: self.contentView.frame.width, height: self.contentView.frame.height - 30)
        scrollView.contentSize = CGSize(width: self.contentView.frame.width * CGFloat(slides.count), height: self.contentView.frame.height)
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: self.scrollView.frame.width * CGFloat(i), y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
            slides[i].dateSelect = { [weak self] date in
                self?.delegate?.dateDidSelect(date.solarDay, date.solarMonth, date.solarYear, date.lunarDay, date.lunarMonth, date.lunarYear)
            }
            scrollView.addSubview(slides[i])
        }
    }
}
