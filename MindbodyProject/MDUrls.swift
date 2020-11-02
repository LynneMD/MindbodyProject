//
//  Utility.swift
//  MindbodyProject
//
//  Created by Lynne on 10/29/20.
//

import Foundation

///
struct MDUrls {
    static let countryUrl = "https://connect.mindbodyonline.com/rest/worldregions/country"
    static let baseUrl = "https://connect.mindbodyonline.com/rest/worldregions/country/"
    static let imageBaseUrl = "https://www.countryflags.io/"
    static var provinceUrl:String?
    
    // Create url for province with selected id of country.
    static func provinceUrlFrom(id:String){
        self.provinceUrl = baseUrl + id + "/province"
    }
    
    // Create url for fetching flag image with code of countries.
    static func countryImageFrom(code:String)->String?{
        let imageUrl = imageBaseUrl + code + "/flat/64.png"
        return imageUrl
    }
}


