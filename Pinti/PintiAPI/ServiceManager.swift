//
//  ServiceManager.swift
//  Pinti
//
//  Created by Emin on 27.12.2020.
//

import Foundation
import Moya
import Alamofire
typealias APIResult<T> = Result<T,MoyaError>

class DefaultAlamofireSession: Alamofire.Session {
    static let shared: DefaultAlamofireSession = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = 120 // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = 120 // as seconds, you can set your resource timeout
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return DefaultAlamofireSession(configuration: configuration)
    }()
}
public final class ServiceManager {
    
    fileprivate let provider = MoyaProvider<PintiAPI>(session: DefaultAlamofireSession.shared, plugins: [NetworkLoggerPlugin()])
    
    fileprivate var jsonDecoder = JSONDecoder()

    public static let shared = ServiceManager()

    fileprivate func fetch<M: Decodable>(target: PintiAPI,
                                         completion: @escaping (_ result: APIResult<M>) -> Void ) {
        
        provider.request(target) { (result) in

            switch result {
            case .success(let response):

                do {

                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    let mappedResponse = try filteredResponse.map(M.self, atKeyPath: nil, using: self.jsonDecoder, failsOnEmptyData: false)
                    let urlResponse = response.response as! HTTPURLResponse
                    
                    completion(.success(mappedResponse))
                } catch MoyaError.statusCode(let response) {
                    if response.statusCode == 401 {

                    }
                    completion(.failure(MoyaError.statusCode(response)))
                } catch {
                    debugPrint("##ERROR parsing##: \(error.localizedDescription)")
                    let moyaError = MoyaError.requestMapping(error.localizedDescription)
                    completion(.failure(moyaError))
                }
            case .failure(let error):
                debugPrint("##ERROR service:## \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    

    func fetchLastProducts(completion: @escaping (_ result: APIResult<[Product]>) -> Void) {
        fetch(target: .fetchLastProducts, completion: completion)
    }
    
    func fetchCategories(completion: @escaping (_ result: APIResult<[Category]>) -> Void) {
        fetch(target: .fetchCategories, completion: completion)
    }
    
    func fetchShops(completion: @escaping (_ result: APIResult<[Shop]>) -> Void) {
        fetch(target: .fetchShops, completion: completion)
    }
    
    func fetchProductsByShop(shopId: String, completion: @escaping (_ result: APIResult<[Product]>) -> Void) {
        fetch(target: .fetchProductsByShopId(id: shopId), completion: completion)
    }
    
    func fetchProductsByCategory(categoryId: String, completion: @escaping (_ result: APIResult<[Product]>) -> Void) {
        fetch(target: .fetchProductsByCategoryId(id: categoryId), completion: completion)
    }
    
    func findProduct(barcode: String, completion: @escaping (_ result: APIResult<[Product]>) -> Void) {
        fetch(target: .findProduct(barcode: barcode), completion: completion)
    }
    
    func addRecord(barcode: String, shopId: String, price: Double, locationTitle: String, locationCoordinate: String, completion: @escaping (_ result: APIResult<SuccessModel>) -> Void) {
        fetch(target: .addRecord(barcode: barcode, shopId: shopId, price: price, locationTitle: locationTitle, locationCoordinate: locationCoordinate), completion: completion)
    }
    
    func addProduct(barcode: String, brand: String, categoryId: String, photoURL: String, name: String, completion: @escaping (_ result: APIResult<SuccessModel>) -> Void) {
        fetch(target: .addProduct(barcode: barcode, brand: brand, name: name, categoryId: categoryId, photoURL: photoURL), completion: completion)
    }
    
    func search(query: String, completion: @escaping (_ result: APIResult<[Product]>) -> Void) {
        fetch(target: .search(query: query), completion: completion)
        
    }
    
    func createUserDb(name: String, email: String, photoURL: String, uid: String, completion: @escaping (_ result: APIResult<SuccessModel>) -> Void) {
        fetch(target: .createUserDb(name: name, email: email, photoURL: photoURL, uid: uid), completion: completion)
    }
    
    func fetchUserInfos(uid: String, completion: @escaping (_ result: APIResult<UserModel>) -> Void) {
        fetch(target: .fetchUserInfos(uid: uid), completion: completion)
    }
    
    func ocr(tagURL: String, completion: @escaping (_ result: APIResult<OcrOutput>) -> Void) {
        fetch(target: .ocr(tagURL: tagURL), completion: completion)
    }

}

struct SuccessModel: Codable {
    var success: Bool
}

struct OcrOutput: Codable {
    var output: String
}





