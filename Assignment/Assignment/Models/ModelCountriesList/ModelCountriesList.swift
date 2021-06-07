//
//  ModelCountriesList.swift
//  Assignment
//
//  Created by Srikanth on 04/06/21.
//

import Foundation
struct ModelCountriesList : Codable {
    var country : String?
    var slug : String?
    var iSO2 : String?
    
    enum CodingKeys: String, CodingKey {
        case country = "Country"
        case slug = "Slug"
        case iSO2 = "ISO2"
    }
}

struct ModelError:Codable{
    var message : String?
}
