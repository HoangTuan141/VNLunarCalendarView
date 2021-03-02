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
    var dateSelected: SolarAndLunarDate?
    var dateSelect: ((_ date: SolarAndLunarDate) -> Void)?
    var indexOfDateSelected: Int?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
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
        cell.setupCell(day: listDay[indexPath.row])
        
        // check currentDay
        let date = Date()
        let solarDay = date.day
        let solarMonth = date.month
        let solarYear = date.year
        if listDay[indexPath.row].solarDay == solarDay &&
            listDay[indexPath.row].solarMonth == solarMonth &&
            listDay[indexPath.row].solarYear == solarYear {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.8745098039, blue: 0.7647058824, alpha: 1)
        }
        
        if let dateSelected = self.dateSelected {
            if listDay[indexPath.row] == dateSelected {
                cell.setBorder(width: 2, color: #colorLiteral(red: 0.8705882353, green: 0.4588235294, blue: 0.07843137255, alpha: 1))
            }
        }
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
                        cell.setBorder(width: 2, color: #colorLiteral(red: 0.8705882353, green: 0.4588235294, blue: 0.07843137255, alpha: 1))
                    } else {
                        cell.setBorder(width: 0.5, color: #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1))
                    }
                }
            }
        } else {
            return
        }
        
    }
}
