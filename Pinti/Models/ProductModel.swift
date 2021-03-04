//
//  ProductModel.swift
//  Pinti
//
//  Created by Emin on 29.12.2020.
//

import Foundation

struct Product: Codable, Hashable {
    var categoryId: String
    var barcode: String?
    var photoURL : String?
    var name: String?
    var brand: String?
    var records: [Record]?
    
    enum CodingKeys: String, CodingKey {
        
        case barcode = "barcode"
        case photoURL = "photoURL"
        case name = "name"
        case brand = "brand"
        case records = "Records"
        case categoryId = "categoryId"

    }
}
