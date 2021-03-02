//
//  ExtensionView.swift
//  VNLunarCalendarView
//
//  Created by Hoàng Tuấn on 02/03/2021.
//

import Foundation
import UIKit

extension UIView {
    func getChiGio(hour: Int) -> Chi? {
        switch hour {
        case 23, 0: return .ti
        case 1, 2: return .suu
        case 3, 4: return .dan
        case 5, 6: return .mao
        case 7, 8: return .thin
        case 9, 10: return .ty
        case 11, 12: return .ngo
        case 13, 14: return .mui
        case 15, 16: return .than
        case 17, 18: return .dau
        case 19, 20: return .tuat
        case 21, 22: return .hoi
        default: return nil
        }
    }
    
    func getCanGio(canNgay: Can, chiGio: Chi) -> Can? {
        let indexOfCanNgay = CanChi.Can.firstIndex(of: canNgay)
        let indexOfChiGio = CanChi.Chi.firstIndex(of: chiGio)
        guard let indexCanNgay = indexOfCanNgay, let indexChiGio = indexOfChiGio else { return nil }
        let a = indexCanNgay >= 5 ? indexCanNgay - 5 : indexOfCanNgay
        guard let temp = a else { return nil }
        let indexOfCanGio = (temp * 2) + indexChiGio
        return indexOfCanGio > 9 ? CanChi.Can[indexOfCanGio - 10] : CanChi.Can[indexOfCanGio]
    }
    
    func checkNgay30Tet(solarDay: Int, solarMonth: Int, solarYear: Int) -> Bool {
        let nextDay = getNextDay(currentDay: solarDay, currentMonth: solarMonth, currentYear: solarYear)
        let nextSolarDay = nextDay[0]
        let nextSolarMonth = nextDay[1]
        let nextSolarYear = nextDay[2]
        let nextLunarDate = convertSolar2Lunar(dd: nextSolarDay, mm: nextSolarMonth, yy: nextSolarYear, timeZone: 7)
        let nextLunarDay = nextLunarDate[0]
        let nextLunarMonth = nextLunarDate[1]
        return nextLunarDay == 1 && nextLunarMonth == 1
    }
    
    func getNextDay(currentDay: Int, currentMonth: Int, currentYear: Int) -> [Int] {
        var day = currentDay + 1
        var month = currentMonth
        var year = currentYear
        if day > getNumberDayOfMonth(month: month, year: year) {
            let monthAndYear = getNextMonth(currentMonth: month, currentYear: year)
            month = monthAndYear[0]
            year = monthAndYear [1]
            day = 1
        }
        return [day, month, year]
    }
        
    func getPreviousDay(currentDay: Int, currentMonth: Int, currentYear: Int) -> [Int] {
        var day = currentDay - 1
        var month = currentMonth
        var year = currentYear
        if day < 1 {
            let monthAndYear = getPreviousMonth(currentMonth: month, currentYear: year)
            month = monthAndYear[0]
            year = monthAndYear [1]
            day = getNumberDayOfMonth(month: month, year: year)
        }
        return [day, month, year]
    }
    
    func isLeapYear(year: Int) -> Bool {
        return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0
    }
    
    func getNumberDayOfMonth(month: Int, year: Int) -> Int {
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            return 31
        case 2:
            if isLeapYear(year: year) {
                return 29
            } else {
                return 28
            }
        case 4, 6, 9, 11:
            return 30
        default:
            return 0
        }
    }
    
    func getIndexOfFirstDayInMonth(month: Int, year: Int) -> Int {
        let thu = getThu(dd: 1, mm: month, yy: year)
        let index = CanChi.Thu.firstIndex(of: thu)
        switch index {
        case 0:
            return 6
        default:
            return index! - 1
        }
    }
    
    func getIndexOfLastDayInMonth(month: Int, year: Int) -> Int {
        let thu = getThu(dd: getNumberDayOfMonth(month: month, year: year), mm: month, yy: year)
        let index = CanChi.Thu.firstIndex(of: thu)
        switch index {
        case 0:
            return 6
        default:
            return index! - 1
        }
    }
    
    func getMonthYearAgo(numberOfMonthAgo: Int, currentMonth: Int, currentYear: Int) -> [Int] {
        var month = currentMonth
        var year = currentYear
        for _ in 0 ..< numberOfMonthAgo {
            let previousMonthYear = getPreviousMonth(currentMonth: month, currentYear: year)
            month = previousMonthYear[0]
            year = previousMonthYear[1]
        }
        return [month, year]
    }
    
    func getMonthYearLater(numberOfMonthAgo: Int, currentMonth: Int, currentYear: Int) -> [Int] {
        var month = currentMonth
        var year = currentYear
        for _ in 0 ..< numberOfMonthAgo {
            let previousMonthYear = getNextMonth(currentMonth: month, currentYear: year)
            month = previousMonthYear[0]
            year = previousMonthYear[1]
        }
        return [month, year]
    }
    
    func getPreviousMonth(currentMonth: Int, currentYear: Int) -> [Int] {
        var previousMonth = currentMonth - 1
        var year = currentYear
        if previousMonth < 1 {
            previousMonth = 12
            year -= 1
        }
        return [previousMonth, year]
    }
    
    func getNumberDayOfPreviousMonth(currentMonth: Int, currentYear: Int) -> Int {
        let previousMonthAndYear = getPreviousMonth(currentMonth: currentMonth, currentYear: currentYear)
        let previousMonth = previousMonthAndYear[0]
        let year = previousMonthAndYear[1]
        return getNumberDayOfMonth(month: previousMonth, year: year)
    }
    
    func getNextMonth(currentMonth: Int, currentYear: Int) -> [Int] {
        var nextMonth = currentMonth + 1
        var year = currentYear
        if nextMonth > 12 {
            nextMonth = 1
            year += 1
        }
        return [nextMonth, year]
    }
    
    func getNumberDayOfNextMonth(currentMonth: Int, currentYear: Int) -> Int {
        let nextMonthYear = getNextMonth(currentMonth: currentMonth, currentYear: currentYear)
        let nextMonth = nextMonthYear[0]
        let year = nextMonthYear[1]
        return getNumberDayOfMonth(month: nextMonth, year: year)
    }
    
    
    func createArrayDayOfMonth(month: Int, year: Int) -> [SolarAndLunarDate] {
        let indexOfFirstDay = getIndexOfFirstDayInMonth(month: month, year: year)
        let indexOfLastDay = getIndexOfLastDayInMonth(month: month, year: year)
        
        let numberDayOfMonth = getNumberDayOfMonth(month: month, year: year)
        var array = [SolarAndLunarDate]()
        for i in 1...numberDayOfMonth {
            let lunar = convertSolar2Lunar(dd: i, mm: month, yy: year, timeZone: 7)
            array.append(SolarAndLunarDate(solarDay: i, solarMonth: month, solarYear: year, isDayOfMonth: true, lunarDay: lunar[0], lunarMonth: lunar[1], lunarYear: lunar[2]))
        }
        if indexOfFirstDay != 0 {
            let numberDayOfPreviousMonth = getNumberDayOfPreviousMonth(currentMonth: month, currentYear: year)
            var previousMonth = month - 1
            var year = year
            if previousMonth < 1 {
                previousMonth = 12
                year -= 1
            }
            for i in 0..<indexOfFirstDay {
                let day = numberDayOfPreviousMonth - i
                let lunar = convertSolar2Lunar(dd: day, mm: previousMonth, yy: year, timeZone: 7)
                array.insert(SolarAndLunarDate(solarDay: day, solarMonth: previousMonth, solarYear: year, isDayOfMonth: false, lunarDay: lunar[0], lunarMonth: lunar[1], lunarYear: lunar[2]), at: 0)
                
            }
        }
        
        if indexOfLastDay != 6 {
            var nextMonth = month + 1
            var year = year
            if nextMonth > 12 {
                nextMonth = 1
                year += 1
            }
            for i in 1...(6-indexOfLastDay) {
                let lunar = convertSolar2Lunar(dd: i, mm: nextMonth, yy: year, timeZone: 7)
                array.append(SolarAndLunarDate(solarDay: i, solarMonth: nextMonth, solarYear: year, isDayOfMonth: false, lunarDay: lunar[0], lunarMonth: lunar[1], lunarYear: lunar[2]))
            }
        }
        
        return array
    }
}

extension UIView {
   func getJulianDayNumber(day: Int, month: Int, year: Int) -> Int {
       let a = INT(Double((14 - month) / 12))
       let y = year + 4800 - a
       let m = month + 12 * a - 3
       var JDN = 0
       JDN += day + INT(Double(((153 * m + 2)/5)))
       JDN += 365 * y
       JDN += INT(Double((y/4))) - INT(Double((y/100)))
       JDN += INT(Double((y/400))) - 32045
       return JDN
   }

   func getJulianDate(day: Int, month: Int, year: Int, hour: Int, minute: Int, second: Int)-> Double {
       let JDN = getJulianDayNumber(day: day, month: month, year: year)
       var JD: Double = 0
       JD = Double(JDN) - 0.5
       JD += (Double(hour) - 7.0) / 24.0
       JD += Double(minute) / 1440.0
       return JD
   }

   func solarLongitude(day: Int, month: Int, year: Int, hour: Int, minute: Int, second: Int) -> Double {
       let JD = getJulianDate(day: day, month: month, year: year, hour: hour, minute: minute, second: second)
       let T = (JD - 2451545.0 ) / 36525; // Time in Julian centuries from 2000-01-01 12:00:00 GMT
       let T2 = T*T
       let dr: Double = Double.pi / 180 // degree to radian
       // mean anomaly, degree
       let M = 357.52910 + 35999.05030*T - 0.0001559*T2 - 0.00000048*T*T2
       // mean longitude, degree
       let L0 = 280.46645 + 36000.76983*T + 0.0003032*T2
       // Sun's equation of center
       var C = (1.914600 - 0.004817*T - 0.000014*T2)*sin(dr*M)
       C = C + (0.019993 - 0.000101*T)*sin(dr*2*M) + 0.000290*sin(dr*3*M)
       let theta = L0 + C // true longitude, degree
       // obtain apparent longitude by correcting for nutation and aberration
       let omega = 125.04 - 1934.136 * T
       var lambda = theta - 0.00569 - 0.00478 * sin(omega * dr)
       // Normalize to (0, 360)
       lambda = lambda - Double(360 * (INT(lambda/360))) // Normalize to (0, 2*PI)
       return lambda
   }
           /// <summary>
           /// Tìm tên gọi Thứ của ngày
           /// </summary>
           /// <param name="dd"></param>
           /// <param name="mm"></param>
           /// <param name="yy"></param>
           /// <returns></returns>
    func getThu(dd: Int, mm: Int, yy: Int) -> Thu {
        let jd = jdFromDate(dd: dd, mm: mm, yy: yy)
        return CanChi.Thu[((jd + 1) % 7)]
    }
           /// <summary>
           /// Tìm tên gọi Chi của năm (12 chi)
           /// </summary>
           /// <param name="yy"></param>
           /// <returns></returns>
    func getChiNam(yy: Int) -> Chi {
        return CanChi.Chi[((yy + 8) % 12)]
    }
           /// <summary>
           /// Tìm tên gọi Can của năm (10 can)
           /// </summary>
           /// <param name="yy"></param>
           /// <returns></returns>
    func getCanNam(yy: Int) -> Can {
        return CanChi.Can[((yy + 6) % 10)]
    }
           /// <summary>
           /// Tìm tên gọi Can của ngày
           /// </summary>
           /// <param name="dd"></param>
           /// <param name="mm"></param>
           /// <param name="yy"></param>
           /// <returns></returns>
    func getCanNgay(dd: Int, mm: Int, yy: Int) -> Can {
        let jd = jdFromDate(dd: dd, mm: mm, yy: yy)
        return CanChi.Can[((jd + 9) % 10)]
    }
           /// <summary>
           /// Tìm tên gọi Chi của ngày
           /// </summary>
           /// <param name="dd"></param>
           /// <param name="mm"></param>
           /// <param name="yy"></param>
           /// <returns></returns>
    func getChiNgay(dd: Int, mm: Int, yy: Int) -> Chi {
        let jd = jdFromDate(dd: dd, mm: mm, yy: yy)
        return CanChi.Chi[((jd + 1) % 12)]
    }
           /// <summary>
           /// Tìm tên gọi Chi của tháng (!tháng Âm Lịch)
           /// </summary>
           /// <param name="mm"></param>
           /// <returns></returns>
    func getChiThang(mm: Int) -> Chi{
        // mm la thang Am lich duoc tinh truoc do
        let tam: Int = (mm + 1) % 12; // Thang 11 la thang Ty, thang 12 la thang Suu
        return CanChi.Chi[tam]
    }
           /// <summary>
           /// Tìm tên gọi Can của tháng, năm (!tháng Âm lịch, năm Âm lịch)
           /// </summary>
           /// <param name="mm"></param>
           /// <param name="yy"></param>
           /// <returns></returns>
    func getCanThang(mm: Int, yy: Int) -> Can{
        // mm la thang am lich, yy nam am lich
        let tam = (yy * 12 + mm + 3) % 10
        return CanChi.Can[tam]
    }
    
    func jdFromDate(dd: Int, mm: Int, yy: Int) -> Int {
        let a: Int = (14 - mm) / 12
        let y: Int = yy + 4800 - a
        let m: Int = mm + 12 * a - 3
        var jd: Int = dd + (153 * m + 2) / 5 + 365 * y + y / 4 - y / 100 + y / 400 - 32045
            if jd < 2299161 {
                jd = dd + (153 * m + 2) / 5 + 365 * y + y / 4 - 32083
            }
            //jd = jd - 1721425
        return jd
    }
        /**
         * http://www.tondering.dk/claus/calendar.html
         * Section: Is there a formula for calculating the Julian day number?
         * @param jd - the number of days since 1 January 4713 BC (Julian calendar)
         * @return
         */
    func jdToDate(jd: Int) -> [Int] {
        var a: Int = 0
        var b: Int = 0
        var c: Int = 0
        if jd > 2299160 {
            // After 5/10/1582, Gregorian calendar
            a = jd + 32044
            b = (4 * a + 3) / 146097
            c = a - (b * 146097) / 4
        } else {
            b = 0
            c = jd + 32082
        }
        let d: Int = (4 * c + 3) / 1461
        let e: Int = c - (1461 * d) / 4
        let m: Int = (5 * e + 2) / 153
        let day: Int = e - (153 * m + 2) / 5 + 1
        let month: Int = m + 3 - 12 * (m / 10)
        let year: Int = b * 100 + d - 4800 + m / 10
        return [day, month, year]
    }
        /**
         * Solar longitude in degrees
         * Algorithm from: Astronomical Algorithms, by Jean Meeus, 1998
         * @param jdn - number of days since noon UTC on 1 January 4713 BC
         * @return
         */
    func SunLongitude(jdn: Double) -> Double {
            //return CC2K.sunLongitude(jdn)
        return SunLongitudeAA98(jdn: jdn)
    }
    
    func SunLongitudeAA98(jdn: Double) -> Double {
        let T: Double = (jdn - 2451545.0) / 36525 // Time in Julian centuries from 2000-01-01 12:00:00 GMT
        let T2: Double = T * T
        let dr: Double = Double.pi / 180 // degree to radian
        let M: Double = 357.52910 + 35999.05030 * T - 0.0001559 * T2 - 0.00000048 * T * T2 // mean anomaly, degree
        let L0: Double = 280.46645 + 36000.76983 * T + 0.0003032 * T2 // mean longitude, degree
        var DL: Double = (1.914600 - 0.004817 * T - 0.000014 * T2) * sin(dr * M)
        DL = DL + (0.019993 - 0.000101 * T) * sin(dr * 2 * M) + 0.000290 * sin(dr * 3 * M)
        var L: Double = L0 + DL // true longitude, degree
        L = L - Double(360) * Double((INT(L / 360))) // Normalize to (0, 360)
        return L
    }
    
    func INT(_ d: Double) -> Int {
        return Int(floor(d))
    }
    
    func NewMoon(k: Int) -> Double{
        //return CC2K.newMoonTime(k)
        return NewMoonAA98(k: k)
    }
        /**
         * Julian day number of the kth new moon after (or before) the New Moon of 1900-01-01 13:51 GMT.
         * Accuracy: 2 minutes
         * Algorithm from: Astronomical Algorithms, by Jean Meeus, 1998
         * @param k
         * @return the Julian date number (number of days since noon UTC on 1 January 4713 BC) of the New Moon
         */

    func NewMoonAA98(k: Int) -> Double {
        let T: Double = Double(k) / 1236.85 // Time in Julian centuries from 1900 January 0.5
        let T2: Double = T * T
        let T3: Double = T2 * T
        let dr: Double = Double.pi / 180
        let Jd1Temp0 = 29.53058868 * Double(k)
        let Jd1Temp1 = 0.0001178 * T2
        let Jd1Temp2 = 0.000000155 * T3
        var Jd1: Double = 2415020.75933 + Jd1Temp0 + Jd1Temp1 - Jd1Temp2
        let Jd1Temp3 = 132.87 * T
        let Jd1Temp4 = 0.009173 * T2
        let Jd1Temp5 = 166.56 + Jd1Temp3 - Jd1Temp4
        Jd1 = Jd1 + 0.00033 * sin((Jd1Temp5) * dr) // Mean new moon
        let MTemp0 = 29.10535608 * Double(k)
        let MTemp1 = 0.0000333 * T2
        let MTemp2 = 0.0000333 * T2
        let M: Double = 359.2242 + MTemp0 - MTemp1 - MTemp2 // Sun's mean anomaly
        let MprTemp0 = 385.81691806 * Double(k)
        let MprTemp1 = 0.0107306 * T2
        let MprTemp2 = 0.00001236 * T3
        let Mpr: Double = 306.0253 + MprTemp0 + MprTemp1 + MprTemp2 // Moon's mean anomaly
        let FTemp0 = 390.67050646 * Double(k)
        let FTemp1 = 0.0016528 * T2
        let FTemp2 = 0.0016528 * T2
        let F: Double = 21.2964 + FTemp0 - FTemp1 - FTemp2 // Moon's argument of latitude
        var C1: Double = (0.1734 - 0.000393 * T) * sin(M * dr) + 0.0021 * sin(2 * dr * M)
        C1 = C1 - 0.4068 * sin(Mpr * dr) + 0.0161 * sin(dr * 2 * Mpr)
        C1 = C1 - 0.0004 * sin(dr * 3 * Mpr)
        C1 = C1 + 0.0104 * sin(dr * 2 * F) - 0.0051 * sin(dr * (M + Mpr))
        C1 = C1 - 0.0074 * sin(dr * (M - Mpr)) + 0.0004 * sin(dr * (2 * F + M))
        C1 = C1 - 0.0004 * sin(dr * (2 * F - M)) - 0.0006 * sin(dr * (2 * F + Mpr))
        C1 = C1 + 0.0010 * sin(dr * (2 * F - Mpr)) + 0.0005 * sin(dr * (2 * Mpr + M))
        var deltat: Double = 0
        if (T < -11) {
            deltat = 0.001 + 0.000839 * T + 0.0002261 * T2 - 0.00000845 * T3 - 0.000000081 * T * T3
        } else {
            deltat = -0.000278 + 0.000265 * T + 0.000262 * T2
        }
        let JdNew: Double = Jd1 + C1 - deltat
        return JdNew
    }
    
    func getSunLongitude(dayNumber: Int, timeZone: Double) -> Double{
        return SunLongitude(jdn: Double(dayNumber) - 0.5 - timeZone / 24)
    }
     
    func getNewMoonDay(k: Int, timeZone: Double) -> Int {
        let jd: Double = NewMoon(k: k)
        return INT(jd + 0.5 + timeZone / 24)
    }
    
    func getLunarMonth11(yy: Int, timeZone: Double) -> Int{
        let off: Double = Double(jdFromDate(dd: 31, mm: 12, yy: yy)) - 2415021.076998695
        let k: Int = INT(off / 29.530588853)
        var nm: Int = getNewMoonDay(k: k, timeZone: timeZone)
        let sunLong: Int = INT(getSunLongitude(dayNumber: nm, timeZone: timeZone) / 30)
        if sunLong >= 9 {
            nm = getNewMoonDay(k: k - 1, timeZone: timeZone)
        }
        return nm
    }
    
    func getLeapMonthOffset(a11: Int, timeZone: Double) -> Int{
        let a = Double(a11) - 2415021.076998695
        let k: Int = INT(0.5 + a / 29.530588853)
        var last = 0// Month 11 contains point of sun longutide 3*PI/2 (December solstice)
        var i = 1 // We start with the month following lunar month 11
        var arc = INT(getSunLongitude(dayNumber: getNewMoonDay(k: k + i, timeZone: timeZone), timeZone: timeZone) / 30)
        repeat {
            last = arc
            i += 1
            arc = INT(getSunLongitude(dayNumber: getNewMoonDay(k: k + i, timeZone: timeZone), timeZone: timeZone) / 30)
        } while (arc != last && i < 14)
        return i - 1
    }
        /**
         *
         * @param dd
         * @param mm
         * @param yy
         * @param timeZone
         * @return array of [lunarDay, lunarMonth, lunarYear, leapOrNot]
         */
    func convertSolar2Lunar(dd: Int, mm: Int, yy: Int, timeZone: Double) -> [Int] {
        var lunarDay: Int = 0
        var lunarMonth: Int = 0
        var lunarYear: Int = 0
        var lunarLeap: Int = 0
        let dayNumber: Int = jdFromDate(dd: dd, mm: mm, yy: yy)
        let k: Int = INT((Double(dayNumber) - 2415021.076998695) / 29.530588853)
        var monthStart: Int = getNewMoonDay(k: k + 1, timeZone: timeZone)
        if monthStart > dayNumber {
                monthStart = getNewMoonDay(k: k, timeZone: timeZone)
        }
        var a11: Int = getLunarMonth11(yy: yy, timeZone: timeZone)
        var b11: Int = a11
        if a11 >= monthStart {
            lunarYear = yy
            a11 = getLunarMonth11(yy: yy - 1, timeZone: timeZone)
        } else {
            lunarYear = yy + 1
            b11 = getLunarMonth11(yy: yy + 1, timeZone: timeZone)
        }
        lunarDay = dayNumber - monthStart + 1
        let diff: Int = INT(Double((monthStart - a11) / 29))
        lunarLeap = 0
        lunarMonth = diff + 11
        if (b11 - a11) > 365 {
            let leapMonthDiff: Int = getLeapMonthOffset(a11: a11, timeZone: timeZone)
            if diff >= leapMonthDiff {
                lunarMonth = diff + 10
                if diff == leapMonthDiff {
                    lunarLeap = 1
                }
            }
        }
        
        if lunarMonth > 12 {
            lunarMonth = lunarMonth - 12
        }
        
        if lunarMonth >= 11 && diff < 4 {
            lunarYear -= 1
        }
        return [lunarDay, lunarMonth, lunarYear, lunarLeap]
    }
    
    func convertLunar2Solar(lunarDay: Int, lunarMonth: Int, lunarYear: Int, lunarLeap: Int, timeZone: Double) -> [Int] {
        var a11 = 0
        var b11 = 0
        if lunarMonth < 11 {
            a11 = getLunarMonth11(yy: lunarYear - 1, timeZone: timeZone)
            b11 = getLunarMonth11(yy: lunarYear, timeZone: timeZone)
        } else {
            a11 = getLunarMonth11(yy: lunarYear, timeZone: timeZone)
            b11 = getLunarMonth11(yy: lunarYear + 1, timeZone: timeZone)
        }
        let temp0 = Double(a11) - 2415021.076998695
        let k: Int = INT(0.5 + temp0 / 29.530588853)
        var off = lunarMonth - 11
        if off < 0 {
            off += 12
        }
        
        if (b11 - a11) > 365 {
            let leapOff: Int = getLeapMonthOffset(a11: a11, timeZone: timeZone)
            var leapMonth: Int = leapOff - 2
            if (leapMonth < 0) {
                leapMonth += 12
            }
            
            if (lunarLeap != 0 && lunarMonth != leapMonth) {
                return [0, 0, 0 ]
            } else if (lunarLeap != 0 || off >= leapOff) {
                off += 1
            }
        }
        let monthStart: Int = getNewMoonDay(k: k + off, timeZone: timeZone)
        return jdToDate(jd: monthStart + lunarDay - 1)
    }
}
