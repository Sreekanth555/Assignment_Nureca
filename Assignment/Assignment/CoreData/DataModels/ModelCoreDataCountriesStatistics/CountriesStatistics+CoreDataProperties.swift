//
//  CountriesStatistics+CoreDataProperties.swift
//  Assignment
//
//  Created by Srikanth on 05/06/21.
//
//

import Foundation
import CoreData


extension CountriesStatistics {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CountriesStatistics> {
        return NSFetchRequest<CountriesStatistics>(entityName: "CountriesStatistics")
    }
    
    @NSManaged public var iD: String?
    @NSManaged public var countryName: String?
    @NSManaged public var countryCode: String?
    @NSManaged public var confirmed: Double
    @NSManaged public var deaths: Double
    @NSManaged public var recovered: Double
    @NSManaged public var active: Double
    @NSManaged public var date: String?
    
    var modelCountriesStatistics : ModelCountriesStatistics {
        get {
            return ModelCountriesStatistics(iD: iD, country: countryName, countryCode: countryCode, confirmed: Int(confirmed), deaths: Int(deaths), recovered: Int(recovered), active: Int(active), date: date)
        }
        set {
            self.iD = newValue.iD
            self.countryName = newValue.country
            self.countryCode = newValue.countryCode
            self.date = newValue.date
            self.active = Double(newValue.active ?? 0)
            self.recovered = Double(newValue.recovered ?? 0)
            self.confirmed = Double(newValue.confirmed ?? 0)
            self.deaths = Double(newValue.deaths ?? 0)
        }
    }
}

extension CountriesStatistics : Identifiable {
    
}
