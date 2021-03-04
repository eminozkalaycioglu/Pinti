//
//  CategoriesAndShops.swift
//  Pinti
//
//  Created by Emin on 29.12.2020.
//

import Foundation
import Combine
class CategoriesAndShops: ObservableObject {
    
    @Published var categories: [Category] = []
    @Published var shops: [Shop] = []

    
    init() {
        self.fetchShops()
        self.fetchCategories()
    }
    func fetchCategories(completion: (()->())? = nil) {
        ServiceManager.shared.fetchCategories { (result) in
            switch result {
            case .success(let response):
                self.categories = response
                completion?()
            case .failure: break
                
            }
        }
    }
    
    func findCategoryName(by id: String) -> String? {
        return self.categories.filter({$0.categoryId == id}).first?.categoryName

    }
    func findCategoryId(by name: String) -> String? {
        return self.categories.filter({$0.categoryName == name}).first?.categoryId

    }
    
    func fetchShops(completion: (()->())? = nil) {
        ServiceManager.shared.fetchShops { (result) in
            switch result {
            case .success(let response):
                self.shops = response
                completion?()
            case .failure: break
                
            }
        }
    }
    
    func findShopName(by id: String) -> String? {
       return self.shops.filter({$0.shopId == id}).first?.shopName
    }
    
    func findShopId(by name: String) -> String? {
       return self.shops.filter({$0.shopName == name}).first?.shopId
    }
    
}



