//
//  DalleeViewModel.swift
//  Dallee
//
//  Created by Raúl Ferrer on 26/12/22.
//

import Foundation

struct ImageResponse: Decodable {
    let data: [ImageUrl]
}

struct ImageUrl: Decodable {
    let url: URL
}


@MainActor
class DalleeViewModel: ObservableObject {
    @Published var imageURL: URL?
    @Published var isLoading = false
    @Published var error: Error?
    
    func generateImage(query: String) {
        guard !query.isEmpty else {
            return
        }
        
        isLoading = true
        error = nil
        
        APIClient<ImageResponse>.request(endpoint: .generateImage(prompt: query)) { result in
            DispatchQueue.main.async {
                self.isLoading = false                
                switch result {
                    case .success(let response):
                        self.imageURL = response.data.first?.url
                    case .failure(let error):
                        self.error = error
                }
            }
        }
    }
}
