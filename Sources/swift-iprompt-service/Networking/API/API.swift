//
//  API.swift
//  swift-iprompt-service
//
//  Created by qinwenzhou on 2026/1/18.
//

import Foundation
import Alamofire

public enum API: String {
    case userRegister = "/user/register"
    case userLoginEmail = "/user/login/email"
    case userTokenRefresh = "/user/token/refresh"
    case userMe = "/user/me"
    
    case promptList = "/prompt/list"
    case promptCreate = "/prompt/create"
    case promptInfo = "/prompt/info"
    case promptDelete = "/prompt/delete"
    
    case tagList = "/tag/list"
    case tagCreate = "/tag/create"
    case tagInfo = "/tag/info"
    case tagDelete = "/tag/delete"
    case tagDeleteList = "/tag/delete/list"
}

 extension API {
     func url(v: Int) -> URL {
         let baseURL = Networking.getBaseURL()
         return baseURL.appending(path: "/api/v\(v)")
     }
}

extension JSONParameterEncoder {
    internal static var snakeCase: JSONParameterEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        return JSONParameterEncoder(encoder: encoder)
    }
}

extension JSONDecoder {
    internal static var snakeCase: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
