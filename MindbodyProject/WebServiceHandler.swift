//
//  WebServiceHandler.swift
//  MindbodyProject
//
//  Created by Lynne on 10/30/20.
//

import Foundation

/// Service talking to the backend.
struct WebServiceHandler {
    
    private let session = URLSession.shared
    
    /// Fetches a list of countries from the backend.
    /// -Parameters:
    ///   callbackQueue: A dispath queue that the completion closure will be invoked on.
    ///   completion: A closure to be executed when the task is finished.
    func fetchCountryLists(callbackQueue:DispatchQueue, completion:@escaping (([Country]?, MDError?)->Void)){
        guard let url = URL(string: MDUrls.countryUrl) else{
            return
        }
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else{
                callbackQueue.async {
                    guard let err = error?.localizedDescription else{
                        return
                    }
                    completion(/*[Country]=*/nil, MDError.backend(err))
                }
                return
            }
            do{
                guard let contents = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:Any]] else{
                    return
                }
                guard let countries = WebServiceUtility.countryDataFrom(input: contents) else {
                    return
                }
                callbackQueue.async {
                    completion(countries, /*Error=*/nil)
                }
            }catch{
                callbackQueue.async {
                    completion(/*[Country]=*/nil, MDError.json)
                }
            }
        }
        task.resume()
    }
    
    /// Fetches a list of provinces from the backend.
    /// -Parameters:
    ///   country: Unique string identifying a country.
    ///   callbackQueue: A dispath queue that the completion closure will be invoked on.
    ///   completion: A closure to be executed when the task is finished.
    func fetchProvinceLists(country:String, callbackQueue:DispatchQueue, completion:@escaping (([Province]?, MDError?)->Void)){
        let provinceStr = MDUrls.provinceUrlFrom(country: country)
        guard let url = URL(string: provinceStr) else{
            return
        }
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else{
                callbackQueue.async {
                    guard let err = error?.localizedDescription else{
                        return
                    }
                    completion(/*[Country]=*/nil, MDError.backend(err))
                }
                return
            }
            do{
                guard let contents = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:Any]] else{
                    return
                }
                let provinces = WebServiceUtility.provinceDataFrom(input: contents)
                callbackQueue.async {
                    completion(provinces, /*Error=*/nil)
                }
            }catch{
                callbackQueue.async {
                    completion(/*[Country]=*/nil, MDError.json)
                }
            }
        }
        task.resume()
    }
    
    /// Fetches the coordinates of a country's capital.
    /// -Parameters:
    ///   country: Unique string identifying a country.
    ///   callbackQueue: A dispath queue that the completion closure will be invoked on.
    ///   completion: A closure to be executed when the task is finished.
    func fetchCountryCordinates(country code:String, callbackQueue:DispatchQueue, completion:@escaping (((Double, Double)?, MDError?)->Void)){
        let cordinateStr = MDUrls.countryCordinatesUrlFrom(country: code)
        guard let url = URL(string: cordinateStr) else{
            return
        }
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else{
                callbackQueue.async {
                    guard let err = error?.localizedDescription else{
                        return
                    }
                    completion(/*coordinates=*/nil, MDError.backend(err))
                }
                return
            }
            do{
                guard let contents = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any] else{
                    return
                }
                let coordinates = WebServiceUtility.coordinatesFrom(input: contents)
                callbackQueue.async {
                    completion(coordinates, /*Error=*/nil)
                }
            }catch{
                callbackQueue.async {
                    completion(/*coordinates=*/nil, MDError.json)
                }
            }
        }
        task.resume()
    }
}
