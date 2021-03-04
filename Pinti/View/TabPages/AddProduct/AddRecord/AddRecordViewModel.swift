//
//  AddRecordViewModel.swift
//  Pinti
//
//  Created by Emin on 2.01.2021.
//

import Foundation
import Combine
import UIKit
class AddRecordViewModel: ObservableObject {
    
    let objectWillChange = PassthroughSubject<Void,Never>()
    @Published var loading = false {
        didSet {
            self.objectWillChange.send()
        }
    }
    @Published var exist: Bool = false {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    @Published var hideContent = true {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    
    @Published var product: [Product] = [] {
        didSet {
            print("emintest: \(product.first?.name)")
            self.objectWillChange.send()
        }
    }
    @Published var addSuccess: Bool = false
    @Published var price: String?
    init(barcode: String) {
        self.checkExist(barcode: barcode)
        
    }
    
    func checkExist(barcode: String) {
        self.loading = true
        ServiceManager.shared.findProduct(barcode: barcode) { (result) in
            switch result {
            case .success(let response):
                self.exist = response.count > 0
                self.product = response
            case .failure(let error): break
            }
            self.loading = false

        }
        
    }
    
    func addRecord(barcode: String, shopId: String, price: Double, locationTitle: String, locationCoordinate: String) {
        self.loading = true
        ServiceManager.shared.addRecord(barcode: barcode, shopId: shopId, price: price, locationTitle: locationTitle, locationCoordinate: locationCoordinate) { (result) in
            switch result {
            case .success(let response):
                if response.success {
                    self.addSuccess = true
                }
            case .failure(let error):
                break
            }
            self.loading = false

        }
    }
    
    func addProduct(barcode: String, brand: String, categoryId: String, productPhoto: UIImage, name: String, completion: (()->())? = nil) {
        self.loading = true
        FirebaseManager.shared.uploadImagePic(img1: productPhoto, barcode: barcode) { (url) in
            
            let urlStr = url?.description ?? "https://erp.netbizde.com/cdn/static/products/default.jpg"
            ServiceManager.shared.addProduct(barcode: barcode, brand: brand, categoryId: categoryId, photoURL: urlStr, name: name) { (result) in
                switch result {
                case .success(let response):
                    if response.success {
                        completion?()
                    }
                case .failure(let error): break
                }
                self.loading = false

            }

        }
        
    }
    
    func uploadPriceTag(img: UIImage) {
        FirebaseManager.shared.uploadTag(img1: img) { (downURL) in
            guard let url = downURL else { return }
            self.getPriceFromImage(tagURL: url.absoluteString)
        }
        
    }
    
    func getPriceFromImage(tagURL: String) {
        self.loading = true
        ServiceManager.shared.ocr(tagURL: tagURL) { (result) in
            switch result {
            
            case .success(let response):
                self.price = response.output
                print("emintest: \(response.output)")
            case .failure(_):
                break
            }
            self.loading = false
        }
    }
}

import SwiftUI
extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}


