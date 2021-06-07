//
//  ModelCountriesStatistics.swift
//  Assignment
//
//  Created by Srikanth on 05/06/21.
//

import Foundation
struct ModelCountriesStatistics : Codable {
    let iD : String?
    let country : String?
    let countryCode : String?
    let confirmed : Int?
    let deaths : Int?
    let recovered : Int?
    let active : Int?
    let date : String?
    
    enum CodingKeys: String, CodingKey {
        
        case iD = "ID"
        case country = "Country"
        case countryCode = "CountryCode"
        case confirmed = "Confirmed"
        case deaths = "Deaths"
        case recovered = "Recovered"
        case active = "Active"
        case date = "Date"
    }
}
