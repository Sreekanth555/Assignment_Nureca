//
//  ModelWorldStatistics.swift
//  Assignment
//
//  Created by Srikanth on 05/06/21.
//

import Foundation

struct ModelWorldStatistics : Codable {
    let totalConfirmed : Int?
    let totalDeaths : Int?
    let totalRecovered : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case totalConfirmed = "TotalConfirmed"
        case totalDeaths = "TotalDeaths"
        case totalRecovered = "TotalRecovered"
    }
}
