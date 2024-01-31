//
//  LeftRightViewController.swift
//  JTAppleCalendarEx
//
//  Created by 김지태 on 1/30/24.
//

import UIKit
import JTAppleCalendar

class LeftRightViewController: UIViewController {
    
    @IBOutlet weak var calendarView: JTACMonthView!
    @IBOutlet weak var monthLabel: UILabel!
    
    let df = DateFormatter()
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendarView.ibCalendarDataSource = self
        self.calendarView.ibCalendarDelegate = self
        
        self.calendarView.visibleDates() { visibleDates in
            self.setupMonthLabel(date: visibleDates.monthDates.first!.date)
        }
        
        self.calendarView.allowsMultipleSelection = true
    }
    
    func setupMonthLabel(date: Date) {
        self.df.dateFormat = "달력: MMM"
        // 한국 로케일 설정
        self.df.locale = Locale(identifier: "ko_KR")
        self.monthLabel.text = df.string(from: date)
    }
    
    func handleConfiguration(cell: JTACDayCell?, cellState: CellState) {
        guard let cell = cell as? LeftRightCellView else { return }
        self.handleCellColor(cell: cell, cellState: cellState)
        self.handleCellSelection(cell: cell, cellState: cellState)
    }
    
    func handleCellColor(cell: LeftRightCellView,
                         cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = .black
        } else {
            cell.dateLabel.textColor = .gray
        }
    }
    
    func handleCellSelection(cell: LeftRightCellView,
                             cellState: CellState) {
        cell.selectedView.isHidden = !cellState.isSelected
            switch cellState.selectedPosition() {
            case .left:
                cell.selectedView.layer.cornerRadius = cell.selectedView.frame.height / 2
                cell.selectedView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
            case .middle:
                cell.selectedView.layer.cornerRadius = cell.selectedView.frame.height / 2
                cell.selectedView.layer.maskedCorners = []
            case .right:
                cell.selectedView.layer.cornerRadius = cell.selectedView.frame.height / 2
                cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            case .full:
                cell.selectedView.layer.cornerRadius = cell.selectedView.frame.height / 2
                cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            default: break
            }
    }
    
    
    @IBAction func next(_ sender: Any) {
        self.calendarView.scrollToSegment(.next)
    }
    
    @IBAction func previous(_ sender: Any) {
        self.calendarView.scrollToSegment(.previous)
    }
    
    @IBAction func startDateButton(_ sender: Any) {
        self.calendarView.scrollToSegment(.start)
    }
    
    @IBAction func endDateButton(_ sender: Any) {
        self.calendarView.scrollToSegment(.end)
    }
    
}

extension LeftRightViewController: JTACMonthViewDelegate, JTACMonthViewDataSource {
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        self.handleConfiguration(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "LeftRightCellView", for: indexPath) as! LeftRightCellView

        // DateComponents를 사용하여 두 날짜의 연, 월, 일 부분을 추출합니다.
        let components1 = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let components2 = Calendar.current.dateComponents([.year, .month, .day], from: Date())

        // 두 DateComponents를 비교하여 연, 월, 일 부분이 동일한지 확인합니다.
        if components1.year == components2.year &&
           components1.month == components2.month &&
           components1.day == components2.day {
            cell.todayView.isHidden = false
        } else {
            cell.todayView.isHidden = true
        }
        
        cell.dateLabel.text = cellState.text
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.setupMonthLabel(date: visibleDates.monthDates.first!.date)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        self.handleConfiguration(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        self.handleConfiguration(cell: cell, cellState: cellState)
    }
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        // 현재 날짜를 가져옵니다.
        let startDate = Date()
        var endDate = Date()
        
        // Calendar 인스턴스를 만듭니다.
        let calendar = Calendar.current

        // 날짜 구성 요소를 만듭니다. 여기서는 3개월을 더하려고 하므로 month 속성을 사용합니다.
        var dateComponents = DateComponents()
        dateComponents.month = 3

        // 현재 날짜에 날짜 구성 요소를 추가하여 3개월 후의 날짜를 계산합니다.
        if let futureDate = calendar.date(byAdding: dateComponents, to: startDate) {
            endDate = futureDate
        }
        
        let parameter = ConfigurationParameters(startDate: startDate,
                                                endDate: endDate,
                                                numberOfRows: 6,
                                                generateInDates: .forAllMonths,
                                                generateOutDates: .tillEndOfGrid,
                                                firstDayOfWeek: .sunday)
        return parameter
    }
}
