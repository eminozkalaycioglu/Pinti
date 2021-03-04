//
//  CategoryModel.swift
//  Pinti
//
//  Created by Emin on 29.12.2020.
//

import Foundation

struct Category: Codable, Hashable {

    var categoryId: String?
    var categoryName: String?
    var categoryPhotoURL: String?
    enum CodingKeys: String, CodingKey {
        case categoryId = "categoryId"
        case categoryName = "categoryName"
        case categoryPhotoURL = "photoURL"
        
    }
}
