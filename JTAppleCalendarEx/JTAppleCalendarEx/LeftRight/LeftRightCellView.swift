//
//  LeftRightCellView.swift
//  JTAppleCalendarEx
//
//  Created by 김지태 on 1/30/24.
//

import UIKit
import JTAppleCalendar

class LeftRightCellView: JTACDayCell {
    @IBOutlet weak var todayView: UIView!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.todayView.layer.cornerRadius = self.todayView.frame.width / 2
    }
}
