//
//  NetworkManager.swift
//  Icewrap Test
//

import Foundation
import Network

class NetworkManager {
    
    static let shared = NetworkManager()

    func postFormEncoded<T: Codable>(urlEndPoint: String, parameters: [String: Any],_ method: String = "POST") async throws -> T {
        guard let url = URL(string: Constants.baseUrl + urlEndPoint) else { throw UrlSessionError.invalidUrl }
        return try await makeFormRequest(url: url, method: method, parameters: parameters)
    }
    
    private func performRequest<T: Codable>(request: URLRequest) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw UrlSessionError.invalidUser
        }
        if let jsonString = String(data: data, encoding: .utf8) {
            print(jsonString)
        }
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    private func makeFormRequest<T: Codable>(url: URL, method: String, parameters: [String: Any]) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = createURLEncodedBody(parameters)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        return try await performRequest(request: request)
    }
    
    private func createURLEncodedBody(_ parameters: [String: Any]) -> Data {
        let bodyString = parameters.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        return bodyString.data(using: .utf8) ?? Data()
    }
}
