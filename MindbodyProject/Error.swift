//
//  Error.swift
//  MindbodyProject
//
//  Created by Lynne on 10/30/20.
//

import Foundation

/// Custom error.
enum MDError:Error {
    case unknown
    case json
    case backend(String)
}

extension MDError{
    var description:String{
        switch self {
        case .unknown:
            return "Unknown Error"
        case .json:
            return "Can not parse data."
        case .backend(let reason):
            return reason
        }
    }
}
