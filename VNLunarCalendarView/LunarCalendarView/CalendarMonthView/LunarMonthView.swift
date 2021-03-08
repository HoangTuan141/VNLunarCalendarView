//
//  LunarMonthView.swift
//  VNLunarCalendarView
//
//  Created by Hoàng Tuấn on 02/03/2021.
//

import Foundation
import UIKit

class LunarMonthView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var listDay : [SolarAndLunarDate] = [SolarAndLunarDate]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var currentSolarDay = 0
    var currentSolarMonth = 0
    var currentSolarYear = 0
    
    var dateSelected: SolarAndLunarDate?
    var dateSelect: ((_ date: SolarAndLunarDate) -> Void)?
    var indexOfDateSelected: Int?
    
    var backgroundCurrentDay = #colorLiteral(red: 0.9843137255, green: 0.8745098039, blue: 0.7647058824, alpha: 1)
    var backgroundDateSelectedColor = UIColor.clear
    var borderColorDay = UIColor.clear
    var borderWidthDay: CGFloat = 0
    var borderColorDaySelected = UIColor.clear
    var borderWidthDaySelected: CGFloat = 0
    var height: CGFloat = 50
    var textSolarDayOfCurrentMonthColor = UIColor.black
    var textLunarDayOfCurrentMonthColor = #colorLiteral(red: 0.9803921569, green: 0.5725490196, blue: 0.2, alpha: 1)
    var textSolarDayNotInCurrentMonthColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)
    var textLunarDayNotInCurrentMonthColor = #colorLiteral(red: 1, green: 0.8078431373, blue: 0.6274509804, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        let date = Date()
        self.currentSolarDay = date.day
        self.currentSolarMonth = date.month
        self.currentSolarYear = date.year
        
        let bundleIdentifier = "org.cocoapods.VNLunarCalendarView"
        guard let bundle = Bundle(identifier: bundleIdentifier) else {
            fatalError("Can not find bundle with name: \(bundleIdentifier)")
        }
        bundle.loadNibNamed("LunarMonthView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        viewDidLoad()
    }
    
    private func viewDidLoad() {
        let bundleIdentifier = "org.cocoapods.VNLunarCalendarView"
        guard let bundle = Bundle(identifier: bundleIdentifier) else {
            fatalError("Can not find bundle with name: \(bundleIdentifier)")
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "LunarDayCell", bundle: bundle), forCellWithReuseIdentifier: "LunarDayCell")
    }
}

extension LunarMonthView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listDay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LunarDayCell", for: indexPath) as! LunarDayCell
        cell.contentView.frame = cell.bounds;
        cell.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        cell.setupCell(day: listDay[indexPath.row], textSolarDayOfCurrentMonthColor: textSolarDayOfCurrentMonthColor, textLunarDayOfCurrentMonthColor: textLunarDayOfCurrentMonthColor, textSolarDayNotInCurrentMonthColor: textSolarDayNotInCurrentMonthColor, textLunarDayNotInCurrentMonthColor: textLunarDayNotInCurrentMonthColor)
        
        // check currentDay
        if listDay[indexPath.row].solarDay == self.currentSolarDay &&
            listDay[indexPath.row].solarMonth == self.currentSolarMonth &&
            listDay[indexPath.row].solarYear == self.currentSolarYear {
            cell.contentView.backgroundColor = backgroundCurrentDay
        }
        
        if let dateSelected = self.dateSelected {
            if listDay[indexPath.row] == dateSelected {
                cell.setBorder(width: borderWidthDaySelected, color: borderColorDaySelected.cgColor)
            }
        }
        
        cell.setBorder(width: borderWidthDay, color: borderColorDay.cgColor)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 7)
        return CGSize(width: width, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if listDay[indexPath.row].isDayOfMonth == true {
            self.dateSelect?(listDay[indexPath.row])
            self.indexOfDateSelected = indexPath.row
            guard let index = indexOfDateSelected else { return }
            for i in 0..<self.listDay.count {
                let indexPath = IndexPath(item: i, section: 0)
                if let cell = collectionView.cellForItem(at: indexPath) as? LunarDayCell {
                    if i == index {
                        cell.setBorder(width: borderWidthDaySelected, color: borderColorDaySelected.cgColor)
                        cell.setBackgroundColor(color: self.backgroundDateSelectedColor)
                    } else {
                        if listDay[indexPath.row].solarDay == self.currentSolarDay &&
                            listDay[indexPath.row].solarMonth == self.currentSolarMonth &&
                            listDay[indexPath.row].solarYear == self.currentSolarYear {
                            cell.contentView.backgroundColor = backgroundCurrentDay
                        } else {
                            cell.setBorder(width: 0.5, color: #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1))
                            cell.setBackgroundColor(color: UIColor.clear)
                        }
                    }
                }
            }
        } else {
            return
        }
    }
}
