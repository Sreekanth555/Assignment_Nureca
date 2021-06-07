//
//  Extension.swift
//  Assignment
//
//  Created by Srikanth on 05/06/21.
//

import Foundation
import UIKit

//MARK:- Extension For Int
extension Int {
    public var kmFormatted: String {
        Double(self).kmFormatted
    }
    public var groupingFormatted: String {
        NumberFormatter.groupingFormatter.string(from: NSNumber(value: self))!
    }
    
    public var radians: Double { Double(self).radians }
    
    public static func random() -> Int { random(in: 1..<max) }
}
//MARK:- Extension For Double
extension Double {
    public var kmFormatted: String {
        if self >= 1_000, self < 1_000_000 {
            return NumberFormatter.groupingFormatter.string(from: NSNumber(value: self / 1_000))! + "k"
        }
        
        if self >= 1_000_000 {
            return NumberFormatter.groupingFormatter.string(from: NSNumber(value: self / 1_000_000))! + "m"
        }
        
        return NumberFormatter.groupingFormatter.string(from: NSNumber(value: self))!
    }
    
    public var percentFormatted: String {
        NumberFormatter.percentFormatter.string(from: NSNumber(value: self))!
    }
    
    public var radians: Double { self * Double.pi / 180 }
}
//MARK:- Extension For NumberFormater
extension NumberFormatter {
    public static let groupingFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.groupingSize = 3
        formatter.maximumFractionDigits = 1
        return formatter
    }()
    
    public static let percentFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1
        return formatter
    }()
}
//MARK:- Extension For Time Zone,Calendar,Date And Locale
extension TimeZone {
    public static let utc = TimeZone(identifier:Constants.utcTimeZone)!
}
extension Calendar {
    public static let posix: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = .posix
        calendar.timeZone = .utc
        return calendar
    }()
}
extension Date {
    public static let reference = Calendar.posix.date(from: DateComponents(year: 2_000))!
    
    public static func fromReferenceDays(days: Int) -> Date {
        Calendar.posix.date(byAdding: .day, value: days, to: Date.reference)!
    }
    public var referenceDays: Int {
        Calendar.posix.dateComponents([.day], from: Date.reference, to: self).day!
    }
}
extension Locale {
    public static let posix = Locale(identifier: Constants.localeIdentifier)
}
