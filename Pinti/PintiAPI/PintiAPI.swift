//
//  PintiAPI.swift
//  Pinti
//
//  Created by Emin on 27.12.2020.
//

import Foundation
import Moya

enum PintiAPI {
    case fetchLastProducts
    case fetchCategories
    case fetchShops
    case fetchProductsByShopId(id: String)
    case fetchProductsByCategoryId(id: String)
    
    case findProduct(barcode: String)
    case addProduct(barcode: String, brand: String, name: String, categoryId: String, photoURL: String)
    case addRecord(barcode: String, shopId: String, price: Double, locationTitle: String, locationCoordinate: String)
    case search(query: String)
    
    case createUserDb(name: String, email: String, photoURL: String, uid: String)
    case fetchUserInfos(uid: String)
    
    case ocr(tagURL: String)
}




extension PintiAPI: TargetType {
    var withoutParameters: Task {
        return .requestParameters(parameters: [String : Any](), encoding: URLEncoding.default)
    }

    
    
    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    public var baseURL: URL {
        switch self {
        case .ocr:
            return URL(string: "https://pinti-ocr.herokuapp.com")!
        default :
            return URL(string: "https://pinti-api.herokuapp.com")!

        }
        

    }

    public var path: String {
        switch self {
        case .fetchLastProducts:
            return "/fetch-last-products"
        case .fetchCategories:
            return "/fetch-categories"
        case .fetchShops:
            return "/fetch-shops"
        
        case .fetchProductsByShopId:
            return "/fetch-products-by-shop"
        case .fetchProductsByCategoryId:
            return "/fetch-products-by-category"
            
        case .findProduct:
            return "/find-product"
            
        case .addRecord:
            return "/add-record"
            
        case .addProduct:
            return "/add-product"
            
        case .search:
            return "/search-product"
            
        case .createUserDb:
            return "/create-user"
            
        case .fetchUserInfos:
            return "/find-user"
            
        case .ocr:
            return "/ocr"
        }
        
        
        
    }

    public var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }

    public var sampleData: Data {
        return Data()
    }

    public var task: Task {
        
        switch self {
        case .fetchProductsByShopId(let id):
            return .requestParameters(parameters: ["shopid" : id], encoding: URLEncoding.default)
        case .fetchProductsByCategoryId(let id):
            return .requestParameters(parameters: ["categoryid" : id], encoding: URLEncoding.default)
            
        case .findProduct(let barcode):
            return .requestParameters(parameters: ["barcode" : barcode], encoding: URLEncoding.default)

        case .addRecord(let barcode, let shopId, let price, let title, let coordinate):
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
            let dateStr = dateFormatter.string(from: Date())
            
            return .requestParameters(parameters: [
                "barcode": barcode,
                "ownerid": FirebaseManager.shared.auth.currentUser?.uid ?? "",
                "ownername": CurrentUser.shared.user?.fullName ?? "",
                "shopid": shopId,
                "locationtitle" : title,
                "locationcoordinate" : coordinate,
                "price": price,
                "recorddate": dateStr
            
                

            ], encoding: URLEncoding.default)
            
            

            
        case .addProduct(let barcode, let brand, let name, let categoryId, let photoURL):
            return .requestParameters(parameters: [
                "barcode" : barcode,
                "brand" : brand,
                "categoryid" : categoryId,
                "photourl" : photoURL,
                "name" : name
            
            ], encoding: URLEncoding.default)
            
        case .search(let query):
            return .requestParameters(parameters: ["name": query], encoding: URLEncoding.default)
            
        case .createUserDb(let name, let email, let photoURL, let uid):
            return .requestParameters(parameters: [
                "name" : name,
                "email" : email,
                "profilephotourl" : photoURL,
                "uid" : uid

            ], encoding: URLEncoding.default)
            
        case .fetchUserInfos(let uid):
            return .requestParameters(parameters: [
                "uid" : uid
                
            ], encoding: URLEncoding.default)
            
        case .ocr(let tagURL):
            return .requestParameters(parameters: [
                "url": tagURL
            
            ], encoding: URLEncoding.default)
        default:
            return self.withoutParameters
        
        }
    }
}

