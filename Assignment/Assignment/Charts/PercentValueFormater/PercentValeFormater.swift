//
//  PercentValeFormater.swift
//  Assignment
//
//  Created by Srikanth on 05/06/21.
//

import Foundation
import Charts
class PercentValueFormatter: DefaultValueFormatter {
    let minPercent: Double

    init(minPercent: Double = 1) {
        self.minPercent = minPercent

        super.init(formatter: .percentFormatter)
    }

    override func stringForValue(_ value: Double,
                                 entry: ChartDataEntry,
                                 dataSetIndex: Int,
                                 viewPortHandler: ViewPortHandler?) -> String {
        if value < minPercent {
            return ""
        }

        return super.stringForValue(value, entry: entry, dataSetIndex: dataSetIndex, viewPortHandler: viewPortHandler)
    }
}
