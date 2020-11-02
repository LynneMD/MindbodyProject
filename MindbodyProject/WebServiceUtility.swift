//
//  WebServiceManager.swift
//  MindbodyProject
//
//  Created by Lynne on 10/29/20.
//

import Foundation

///
struct WebServiceUtility {

    static func countryDataFrom(input:[String:Any])->Country?{
        guard let countryId = input["ID"] as? Int else{
            return nil
        }
        guard let countryName = input["Name"] as? String else{
            return nil
        }
        guard let countryCode = input["Code"] as? String else{
            return nil
        }
        guard let img = Utility.countryImageFrom(code: countryCode) else{
            return nil
        }
        return Country(id: countryId, name: countryName, code: countryCode, img: img)
    }
    
    static func provinceDataFrom(input:[String:Any])->Province?{
        guard let provinceName = input["Name"] as? String else{
            return nil
        }
        return Province(provinceName: provinceName)
    }
}
