//
//  CountriesList+CoreDataProperties.swift
//  Assignment
//
//  Created by Srikanth on 05/06/21.
//
//

import Foundation
import CoreData


extension CountriesList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CountriesList> {
        return NSFetchRequest<CountriesList>(entityName: "CountriesList")
    }

    @NSManaged public var countryName: String?

}

extension CountriesList : Identifiable {

}
