//
//  HomepageViewModel.swift
//  Pinti
//
//  Created by Emin on 27.12.2020.
//

import Foundation
import Combine

class HomepageViewModel: ObservableObject {
    @Published var loading = false{
        didSet {
            self.objectWillChange.send()
        }
    }
    @Published var products: [Product]?
    let objectWillChange = PassthroughSubject<Void,Never>()

    
    func fetchLastProducts() {
        self.loading = true
        ServiceManager.shared.fetchLastProducts { (result) in
            switch result {
            case .success(let response):
                self.products = response
            case .failure(let error):
                print(error)
                
            }
            self.loading = false

        }
    }
}
