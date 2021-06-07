//
//  Constants.swift
//  Assignment
//
//  Created by Srikanth on 04/06/21.
//

import Foundation
import Alamofire

// MARK: -   Constants
let context = CoreDataManager.sharedManager.persistentContainer.viewContext

struct Constants {
    static let error = "Error"
    static let alert = "Alert!"
    static let covidStatistics = "Covid Statistics"
    static let confirmed = "Confirmed"
    static let recovered = "Recovered"
    static let deaths = "Deaths"
    static let fontName = "HelveticaNeue"
    static let reUseIdentifierCell = "cell"
    static let ok = "Ok"
    static let utcTimeZone = "UTC"
    static let localeIdentifier = "en_US_POSIX"
    static let recentlyViewedCountries = "Recently viewed countries"
    static let noInternetAvailable = "No internet connection. Make sure that Wi-Fi or mobile data is turned on, then try again."
    static let loading = "Loading..."
}
//MARK:- StoryBoard Identifiers
struct SBIdentifiers {
    static let  statisticsViewController_SBIdentifier = "statisticsViewController"
}
// MARK: -  Url Constants
struct UrlConstants {
    static let baseUrl = "https://api.covid19api.com/"
    static let urlGetCountriesList = "countries"
    static let urlGetStatistics = "country/"
    static let urlWorldTotal = "world/total"
}
// MARK: -  Headers
struct Headers {
    func httpHeaders() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        return headers
    }
}
