//
//  BasicViewController.swift
//  JTAppleCalendarEx
//
//  Created by 김지태 on 1/30/24.
//

import UIKit
import JTAppleCalendar

class BasicViewController: UIViewController {

    @IBOutlet weak var calendarView: JTACMonthView!
    @IBOutlet weak var monthLabel: UILabel!
    
    let df = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendarView.ibCalendarDataSource = self
        self.calendarView.ibCalendarDelegate = self
        
        self.calendarView.visibleDates() { visibleDates in
            self.setupMonthLabel(date: visibleDates.monthDates.first!.date)
        }
        
        // 다중 선택 기능
        self.calendarView.allowsMultipleSelection = false
        
        self.calendarView.scrollDirection = .horizontal
        self.calendarView.reloadData()
    }
    
    func setupMonthLabel(date: Date) {
        self.df.dateFormat = "달력: MMM"
        // 한국 로케일 설정
        self.df.locale = Locale(identifier: "ko_KR")
        self.monthLabel.text = df.string(from: date)
    }
    
    func handleConfiguration(cell: JTACDayCell?, cellState: CellState) {
        guard let cell = cell as? BasicCellView else { return }
        self.handleCellColor(cell: cell, cellState: cellState)
        self.handleCellSelection(cell: cell, cellState: cellState)
    }
    
    func handleCellColor(cell: BasicCellView,
                         cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = .black
        } else {
            cell.dateLabel.textColor = .gray
        }
    }
    
    func handleCellSelection(cell: BasicCellView,
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
}

extension BasicViewController: JTACMonthViewDelegate, JTACMonthViewDataSource {
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        self.handleConfiguration(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "BasicCellView", for: indexPath) as! BasicCellView
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
        let df = DateFormatter()
        df.dateFormat = "yyyy MM dd"
        
        let startDate = df.date(from: "2017 01 01")!
        let endDate = df.date(from: "2017 12 31")!
        
        let parameter = ConfigurationParameters(startDate: startDate,
                                                endDate: endDate,
                                                numberOfRows: 6,
                                                generateInDates: .forAllMonths,
                                                generateOutDates: .tillEndOfGrid,
                                                firstDayOfWeek: .sunday)
        return parameter
    }
}
