//
//  Country.swift
//  MindbodyProject
//
//  Created by Lynne on 10/30/20.
//

import Foundation

/// Represnts a country.
class Country{
    let id:Int
    let name:String
    let code:String
    var flag:Data?
    var flagDidLoad:((Data)->Void)?
    
    // Url pointing to the image.
    private let countryImage:String
    
    init(id:Int, name:String, code:String, img:String) {
        self.id = id
        self.name = name
        self.code = code
        self.countryImage = img
    }
    
    func fetchFlag(){
        DispatchQueue.global().async {
            guard let url = URL(string: self.countryImage) else{
                return
            }
            guard let data = try? Data(contentsOf: url) else{
                return
            }
            DispatchQueue.main.async {
                self.flag = data
                self.flagDidLoad?(data)
            }
        }
    }
}
