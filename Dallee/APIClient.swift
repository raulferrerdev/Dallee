//
//  APIClient.swift
//  Dallee
//
//  Created by Raúl Ferrer on 22/12/22.
//

import Foundation

struct DalleParameters: Encodable {
    var prompt: String
    var num_images: Int
    var size: String
}

enum Endpoint {
    
    case generateImage(prompt: String)
    
    var baseUrl: URL {
        switch self {
            case .generateImage:
                return URL(string: "https://api.openai.com")!
        }
    }
    
    var path: String {
        switch self {
            case .generateImage:
                return "/v1/images/generations"
        }
    }
    
    var url: URL {
        switch self {
            case .generateImage:
                return baseUrl.appendingPathComponent(path)
        }
    }
    
    var method: String {
        switch self {
            case .generateImage:
                return "POST"
        }
    }
    
    var parameters: DalleParameters {
        switch self {
            case .generateImage(let prompt):
                return DalleParameters(prompt: prompt, num_images: 1, size: "256x256")
        }
    }
    
    var headers: [String : String] {
        ["Authorization" : "Bearer {YOUR_API_KEY}", "Content-Type" : "application/json"]
    }

    var request: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        request.httpBody = try? JSONEncoder().encode(parameters)
        return request
    }
}

struct APIClient<T: Decodable> {
    static func request(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: endpoint.request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let object = try decoder.decode(T.self, from: data)
                completion(.success(object))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

enum APIError: Error {
    case noData
}
