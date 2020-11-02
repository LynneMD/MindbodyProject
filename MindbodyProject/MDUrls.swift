//
//  Utility.swift
//  MindbodyProject
//
//  Created by Lynne on 10/30/20.
//

import Foundation

/// A collection of endpoints.
struct MDUrls {
    static let countryUrl = "https://connect.mindbodyonline.com/rest/worldregions/country"
    
    private init(){
        // Intentionally mark it as private, so no one can instantiate it.
    }
    
    /// Creates a url for province using a selected country id.
    /// -Parameter: An unique id of a country.
    /// -Return: An url string.
    static func provinceUrlFrom(country id:String) -> String {
        return "https://connect.mindbodyonline.com/rest/worldregions/country/\(id)/province"
    }
    
    /// Creates a url for coordinates of a country's captial using a selected country code.
    /// -Parameter: An unique code of a country.
    /// -Return: An url string.
    static func countryCordinatesUrlFrom(country code:String) -> String {
        return "http://api.worldbank.org/v2/country/\(code)?format=json"
    }
    
    /// Create a url for fetching flag image using a country code.
    /// -Parameter: An unique code of a country.
    /// -Return: An url string.
    static func countryImageFrom(country code:String) -> String {
        return "https://www.countryflags.io/\(code)/flat/64.png"
    }
}


