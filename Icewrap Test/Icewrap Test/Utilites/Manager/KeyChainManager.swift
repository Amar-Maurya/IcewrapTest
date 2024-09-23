//
//  KeyChainManager.swift
//  Icewrap Test
//

import Foundation
import Security

class KeyChainManager {
    static let shared = KeyChainManager()
    
    private let tokenKey = "userToken"

    var token: String? {
        get {
            return retrieveToken()
        }
        set {
            if let token = newValue {
                storeToken(token)
            } else {
                deleteToken()
            }
        }
    }

    private func storeToken(_ token: String) {
        let data = token.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("Error \(status)")
        }
    }

    private func retrieveToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess {
            if let data = dataTypeRef as? Data {
                return String(data: data, encoding: .utf8)
            }
        } else {
            print("Error \(status)")
        }
        
        return nil
    }

    private func deleteToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey
        ]

        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            print("Error \(status)")
        }
    }
}

