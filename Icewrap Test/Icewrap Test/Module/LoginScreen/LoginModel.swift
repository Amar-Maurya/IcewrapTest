//
//  LoginModel.swift
//  Icewrap Test
//

import Foundation

struct LoginRequestModel {
    var username: String?
    var password: String?
    var hostName: String?
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        if let username = username {
            dict["username"] = username
        }
        if let password = password {
            dict["password"] = password
        }
        if let hostName = hostName {
            dict["hostName"] = hostName
        }
        return dict
    }
}

struct LoginResponseModel: Codable {
    let authorized: Bool?
    let token: String?
    let host: String?
    let email: String?
    let ok: Bool?
}
