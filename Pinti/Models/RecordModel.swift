//
//  RecordModel.swift
//  Pinti
//
//  Created by Emin on 29.12.2020.
//

import Foundation

struct Record: Codable, Hashable {
    var barcode: String?
    var price: Float?
    var recordDate: String?
    var shopId: String?
    var locationCoordinate: String?
    var locationTitle: String?
    var ownerId: String?
    var ownerName: String?
    
    enum CodingKeys: String, CodingKey {
        case barcode = "barcode"
        case ownerId = "ownerId"
        case ownerName = "ownerName"

        case price = "price"
        case recordDate = "recordDate"
        case shopId = "shopId"
        case locationCoordinate = "locationCoordinate"
        case locationTitle = "locationTitle"
    }
    
    
}
