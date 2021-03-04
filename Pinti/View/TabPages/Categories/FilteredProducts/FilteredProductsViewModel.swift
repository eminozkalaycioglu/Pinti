//
//  FilteredProductsViewModel.swift
//  Pinti
//
//  Created by Emin on 1.01.2021.
//

import Foundation
import Combine

class FilteredProductsViewModel: ObservableObject {
    @Published var loading: Bool = false {
        didSet {
            self.objectWillChange.send()
        }
    }
    @Published var filteredProducts: [Product] = []
    let objectWillChange = PassthroughSubject<Void,Never>()

    init(categoryId: String?, shopId: String?) {
        
        if categoryId != nil {
            self.fetchProductsByCategory(id: categoryId!)
        }
        if shopId != nil {
            self.fetchProductsByShop(id: shopId!)
        }
        
        
    }
    
    func fetchProductsByShop(id: String) {
        self.loading = true
        ServiceManager.shared.fetchProductsByShop(shopId: id) { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.filteredProducts = response
            case .failure(let error): break
            }
            self?.loading = false

        }
    }
    
    func fetchProductsByCategory(id: String) {
        self.loading = true
        ServiceManager.shared.fetchProductsByCategory(categoryId: id) { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.filteredProducts = response
            case .failure(let error): break
            }
            self?.loading = false

        }
    }
}
