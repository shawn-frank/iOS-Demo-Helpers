//
//  NetworkService.swift
//  Nine News Assessment
//
//  Created by Shawn Frank on 15/3/2023.
//

import Foundation

protocol NetworkService {
    func fetchData<Response: Decodable>(url: URL) async throws -> Response
}

extension NetworkService {
    func fetchData<Response: Decodable>(url: URL) async throws -> Response {
        let urlRequest = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        
        guard let (data, response) = try? await session.data(for: urlRequest) else {
            throw NetworkError.server
        }
        
        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode > 400 {
            throw NetworkError.server
        }
        
        do {
            return try JSONDecoder().decode(Response.self, from: data)
        } catch {
            throw NetworkError.decode
        }
    }
}
