//
//  WebServiceManager.swift
//  MindbodyProject
//
//  Created by Lynne on 10/30/20.
//

import Foundation

/// Utility class for the web server handler.
struct WebServiceUtility {
    
    private init(){
        // Intentionally mark it as private, so no one can instantiate this class.
    }

    /// Converts json into a country object.
    /// -Parameters:
    ///   input: Json array.
    /// -Return: A country object.
    static func countryDataFrom(input:[[String:Any]]) -> [Country]? {
        var countries:[Country] = []
        for content in input{
            guard let countryId = content["ID"] as? Int else {
                return nil
            }
            guard let countryName = content["Name"] as? String else {
                return nil
            }
            guard let countryCode = content["Code"] as? String else {
                return nil
            }
            let img = MDUrls.countryImageFrom(country: countryCode)
            countries.append(Country(id: countryId, name: countryName, code: countryCode, img: img))
        }
        return countries
    }
    
    /// Converts json into a province object.
    /// -Parameters:
    ///   input: Json array.
    /// -Return: A province object.
    static func provinceDataFrom(input:[[String:Any]]) -> [Province] {
        var provinces:[Province] = []
        for content in input {
            guard let provinceName = content["Name"] as? String else {
                return []
            }
            provinces.append(Province(provinceName: provinceName))
        }
        return provinces
    }

    /// Converts json into a turple.
    /// -Parameters:
    ///   input: Json array.
    /// -Return: A turple represeting longitude and latitude.
    static func coordinatesFrom(input:[Any]) -> (Double, Double)?{
        guard let content = input.last as? [[String:Any]] else {
            return nil
        }
        guard let dict = content.first else {
            return nil
        }
        guard let longitude = dict["longitude"] as? String, let latitude = dict["latitude"] as? String else{
            return nil
        }
        guard let long = Double(longitude), let lat = Double(latitude) else{
            return nil
        }
        return (long, lat)
    }
}
