//
//  DayAxisValueFormatter.swift
//  Assignment
//
//  Created by Srikanth on 05/06/21.
//
import UIKit
import Charts
class DayAxisValueFormatter: NSObject, IAxisValueFormatter {
    weak var chartView: BarLineChartViewBase?

    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .utc
        formatter.dateFormat = "MMM yyyy"
        return formatter
    }()

    init(chartView: BarLineChartViewBase) {
        self.chartView = chartView
    }

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date.fromReferenceDays(days: Int(value))
        return formatter.string(from: date)
    }
}
