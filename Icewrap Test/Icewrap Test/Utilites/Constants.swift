//
//  Constants.swift
//  Icewrap Test
//

import Foundation

struct Constants {
    
    struct ValidationError {
        static let emptyField = "star(*) fields cannot be empty."
        static let invalidEmail = "Please enter a valid email address."
        static let passwordTooShort = "Password must be at least 6 characters long."
       
    }
    
    struct URLSessionError {
        static let invalidUrl = "URL is invalid!"
        static let invalidToken = "Token is Invalid!"
        static let inValidUser = "User Credentials is invalid!"
    }
    
    static let baseUrl = "https://mofa.onice.io/teamchatapi/"
    
    struct EndPoint {
        static let login = "iwauthentication.login.plain"
        static let channelList = "channels.list"
    }
}

enum ValidationError: Error {
    case emptyField
    case invalidEmail
    case passwordTooShort

    var localizedDescription: String {
        switch self {
        case .emptyField:
            return Constants.ValidationError.emptyField
        case .invalidEmail:
            return Constants.ValidationError.invalidEmail
        case .passwordTooShort:
            return Constants.ValidationError.passwordTooShort
       
        }
    }
}

enum UrlSessionError: Error {
    case invalidUrl
    case invalidToken
    case invalidUser
    var localizedDescription: String {
        switch self {
        case .invalidUrl:
            return Constants.URLSessionError.invalidUrl
        case .invalidToken:
            return Constants.URLSessionError.invalidToken
        case .invalidUser:
            return Constants.URLSessionError.inValidUser
            
        }
    }
}


