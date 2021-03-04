//
//  ShopModel.swift
//  Pinti
//
//  Created by Emin on 29.12.2020.
//

import Foundation

struct Shop: Codable, Hashable {

    var photoURL: String?
    var shopId: String?
    var shopName: String?
    
    enum CodingKeys: String, CodingKey {
        case photoURL = "photoURL"
        case shopId = "shopId"
        case shopName = "shopName"
        
    }
        
}
