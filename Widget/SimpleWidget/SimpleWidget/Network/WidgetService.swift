//
//  WidgetService.swift
//  SimpleWidget
//
//  Created by Shawn Frank on 24/7/2023.
//

import UIKit

struct WidgetService: NetworkService {
    func fetchData(url: URL) async throws -> Record {
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
            return try JSONDecoder().decode(APIResponse.self, from: data).record
        } catch {
            throw NetworkError.decode
        }
    }
    
    func downloadImage(from url: URL) async throws -> UIImage {
        let data = try await downloadImageData(from: url)
        guard let image = UIImage(data: data) else {
            throw NSError(domain: "ImageErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create image from data"])
        }
        return image
    }

    private func downloadImageData(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
