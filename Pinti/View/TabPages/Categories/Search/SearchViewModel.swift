//
//  SearchViewModel.swift
//  Pinti
//
//  Created by Emin on 4.01.2021.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var products: [Product] = []
    func search(query: String) {
        ServiceManager.shared.search(query: query) { (result) in
            switch result {
            case .success(let response):
                self.products = response
                print("count: \(response.count)")
            case .failure(let error): break
            }
        }
        
    }
}
