//
//  Utils.swift
//  Assignment
//
//  Created by Srikanth on 04/06/21.
//

import Foundation
import UIKit
import Charts

class Utils {
    static let shared = Utils()
    init() {
    }
    // MARK: -  Alert Controller
    func showAlertMsg(_ title:String,_ message:String,_ currentView:UIViewController){
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action:UIAlertAction = UIAlertAction(title: Constants.ok, style: .cancel, handler: nil)
        alert.addAction(action)
        currentView.present(alert, animated: true, completion: nil)
    }
    //MARK:- Get Country Flag By Country Code
    func getCountryFlag(_ countryCode: String) -> String {
        return String(String.UnicodeScalarView(
                        countryCode.unicodeScalars.compactMap(
                            { UnicodeScalar(127397 + $0.value) })))
    }
    //MARK:- Date Converter
    func convertStringvalueToDate(_ strDate:String)->Date  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        let date = dateFormatter.date(from: strDate)
        return date!
    }
    //MARK:- Initialize piechart and assign data
    func initializeUiForPiChartAndAssignData( pieChart: PieChartView, confirmedCases:Int, recoveredCases:Int, deaths:Int)->PieChartView{
        pieChart.usePercentValuesEnabled = true
        pieChart.legend.form = .circle
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        let centerText = NSMutableAttributedString(string: Constants.covidStatistics)
        centerText.setAttributes([.font : UIFont(name: Constants.fontName, size: 15)!,
                                  .paragraphStyle : paragraphStyle,.foregroundColor : UIColor.black], range: NSRange(location: 0, length: centerText.length))
        
        pieChart.centerAttributedText = centerText
        let marker = SimpleMarkerView(chartView: pieChart)
        marker.font = .systemFont(ofSize: 13)
        pieChart.marker = marker
        var dataEntries: [PieChartDataEntry] = []
        dataEntries.append(PieChartDataEntry(value: Double(confirmedCases), label: Constants.confirmed))
        dataEntries.append(PieChartDataEntry(value: Double(recoveredCases), label: Constants.recovered))
        dataEntries.append(PieChartDataEntry(value: Double(deaths), label: Constants.deaths))
        
        let dataSet = PieChartDataSet(entries: dataEntries, label: "")
        dataSet.colors = [.systemYellow, .systemGreen, .systemRed]
        dataSet.valueColors = [
            UIColor(hue: 0.13, saturation: 1.0, brightness: 0.4, alpha: 1.0),
            UIColor(hue: 0.3, saturation: 0.2, brightness: 1.0, alpha: 1.0),
            UIColor(hue: 0.03, saturation: 0.2, brightness: 1.0, alpha: 1.0)
        ]
        dataSet.sliceSpace = 2 * pow(1, 2)
        dataSet.xValuePosition = .outsideSlice
        dataSet.yValuePosition = .insideSlice
        dataSet.entryLabelColor = .black
        dataSet.valueFont = .systemFont(ofSize: 14 , weight: .bold)
        dataSet.valueFormatter = PercentValueFormatter(minPercent: 1 )
        dataSet.selectionShift = 1
        pieChart.data = PieChartData(dataSet: dataSet)
        pieChart.animate(xAxisDuration: 0.8, easingOption: .easeOutBack)
        return pieChart
    }
    //MARK:- Initialize linechart and assign data
    func initializeUiForLineChartAndAssignData(lineChart: LineChartView, arrCountriesStastics:[ModelCountriesStatistics])->LineChartView{
        
        lineChart.xAxis.gridColor = UIColor.lightGray.withAlphaComponent(0.5)
        lineChart.xAxis.gridLineDashLengths = [3, 3]
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.labelTextColor = AppColorSet.gray_Color
        lineChart.xAxis.labelFont = .systemFont(ofSize: 10 )
        lineChart.xAxis.valueFormatter = DayAxisValueFormatter(chartView: lineChart)
        
        lineChart.leftAxis.gridColor = UIColor.lightGray.withAlphaComponent(0.5)
        lineChart.leftAxis.gridLineDashLengths = [3, 3]
        lineChart.leftAxis.labelTextColor = AppColorSet.gray_Color
        lineChart.leftAxis.labelFont = .systemFont(ofSize: 10)
        lineChart.leftAxis.valueFormatter = DefaultAxisValueFormatter { value, _ in
            value.kmFormatted
        }
        
        lineChart.rightAxis.enabled = false
        lineChart.legend.form = .circle
        lineChart.dragEnabled = false
        lineChart.scaleXEnabled = false
        lineChart.scaleYEnabled = false
        
        let marker = SimpleMarkerView(chartView: lineChart) { entry, _ in
            let xValue = lineChart.xAxis.valueFormatter?.stringForValue(entry.x, axis: nil) ?? "-"
            if let value = entry.data as? Double {
                return "\(xValue): \(value.kmFormatted)"
            } else {
                return "\(xValue): \(entry.y.kmFormatted)"
            }
        }
        marker.font = .systemFont(ofSize: 13)
        lineChart.marker = marker
        
        var dictDates = [Date:ModelCountriesStatistics]()
        for countryStastics in arrCountriesStastics{
            if let dtStr = countryStastics.date{
                let date = Utils.shared.convertStringvalueToDate(dtStr)
                dictDates[date] = countryStastics
            }
        }
        
        let arrDates = dictDates.keys.sorted()
        let confirmedEntries = arrDates.map {
            self.createEntry(date: $0, value: Double(dictDates[$0]?.confirmed ?? 0))
        }
        let recoveredEntries = arrDates.map {
            self.createEntry(date: $0, value: Double(dictDates[$0]?.recovered ?? 0))
        }
        let deathsEntries = arrDates.map {
            self.createEntry(date: $0, value: Double(dictDates[$0]?.deaths ?? 0))
        }
        
        let entries = [confirmedEntries,recoveredEntries,deathsEntries]
        let labels = [Constants.confirmed,Constants.recovered,Constants.deaths]
        let colors = [UIColor.systemYellow,.systemGreen,.systemRed]
        var arrDataSets = [LineChartDataSet]()
        for index in entries.indices {
            let dataSet = LineChartDataSet(entries: entries[index], label: labels[index])
            dataSet.mode = .cubicBezier
            dataSet.drawValuesEnabled = false
            dataSet.colors = [colors[index].withAlphaComponent(0.75)]
            dataSet.drawCirclesEnabled = false
            dataSet.circleRadius = 5
            dataSet.circleColors = [colors[index]]
            dataSet.drawCircleHoleEnabled = false
            dataSet.circleHoleRadius = 3
            dataSet.lineWidth = 3
            dataSet.highlightLineWidth = 1
            dataSet.highlightColor = UIColor.lightGray.withAlphaComponent(0.5)
            dataSet.drawHorizontalHighlightIndicatorEnabled = false
            arrDataSets.append(dataSet)
        }
        lineChart.data = LineChartData(dataSets: arrDataSets)
        lineChart.animate(xAxisDuration: 0.5, easingOption: .easeOutQuad)
        return lineChart
    }
    func createEntry(date: Date, value: Double) -> ChartDataEntry {
        let entry = ChartDataEntry(x: Double(date.referenceDays), y: value)
        entry.data = value
        return entry
    }
}
