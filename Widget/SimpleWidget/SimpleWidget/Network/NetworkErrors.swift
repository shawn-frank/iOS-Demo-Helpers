//
//  NetworkErrors.swift
//  Nine News Assessment
//
//  Created by Shawn Frank on 15/3/2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case server
    case decode
    case unknown
    case noInternet
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .server:
            return "Server Error"
        case .decode:
            return "Error parsing response"
        case .unknown:
            return "An unknown error occured"
        case .noInternet:
            return "You do not seem to have a valid internet connection"
        }
    }
}
