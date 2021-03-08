# VNLunarCalendarView
Library reference algorithm for lunar and solar days of author Ho Ngoc Duc
## Installation
### CocoaPods
With CocoaPods you can simply add `VNLunarCalendarView` in your Podfile:<br/>
``` pod 'VNLunarCalendarView'```<br/>
```pod install```
### Source file
You can copy all the files under the Sources folder into your project.
## Usage
* In the storyboard add a UIView and change its class to VNLunarCalendarView
![Screen Shot 2021-03-08 at 10 43 12](https://user-images.githubusercontent.com/54350677/110271797-4bca4c80-7ffb-11eb-95d5-508aa7998d78.png)<br/>


* Connect outlet  of calendar view and height of it to .swift file
* And then
```Swift
import VNLunarCalendarView
```
![Screen Shot 2021-03-08 at 10 50 00](https://user-images.githubusercontent.com/54350677/110272293-6cdf6d00-7ffc-11eb-92e9-98f3c1a204fd.png)

* Properties
![Screen Shot 2021-03-08 at 16 12 52](https://user-images.githubusercontent.com/54350677/110300204-323ff980-8029-11eb-979a-523d3044ee3a.png)

### Example
```Swift
import UIKit
import VNLunarCalendarView

class ViewController: UIViewController {
    @IBOutlet weak var lunarCalendarView: VNLunarCalendarView!
    @IBOutlet weak var heightOfLunarCalendarView: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lunarCalendarView.delegate = self
        lunarCalendarView.setCurrentMonth(month: 3, year: 2021)
        lunarCalendarView.setWeekdayTitle(weekdayTitle: ["T2", "T3", "T4", "T5", "T6", "T7", "CN"])
        lunarCalendarView.setBackgroundColor(.white)
        lunarCalendarView.setBackgroundCurrentDay(#colorLiteral(red: 1, green: 0.9725490196, blue: 0.9411764706, alpha: 1))
        lunarCalendarView.setBackgroundDateSelectedColor(.yellow)
        lunarCalendarView.setBorderColorDay(color: .gray, borderWidth: 0.5)
        lunarCalendarView.setBorderColorDaySelected(color: .orange, borderWidth: 2)
        lunarCalendarView.setHeightOfDayView(height: 50)
        lunarCalendarView.setWeekdayTitleColor(color: .black)
        lunarCalendarView.setTextDayColor(textSolarDayOfCurrentMonthColor: .black, textLunarDayOfCurrentMonthColor: #colorLiteral(red: 0.9803921569, green: 0.5725490196, blue: 0.2, alpha: 1), textSolarDayNotInCurrentMonthColor: #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1), textLunarDayNotInCurrentMonthColor: #colorLiteral(red: 1, green: 0.8078431373, blue: 0.6274509804, alpha: 1))
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
            self.heightOfLunarCalendarView.constant = 231
        case 5:
            self.heightOfLunarCalendarView.constant = 281
        case 6:
            self.heightOfLunarCalendarView.constant = 331
        default:
            return
        }
    }
            
}
```
