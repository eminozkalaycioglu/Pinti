//
//  FirebaseManager.swift
//  Pinti
//
//  Created by Emin on 5.12.2020.
//

import Foundation
import Firebase
class FirebaseManager {
    
    private init() { }
    static let shared = FirebaseManager()
    var auth: Auth {
        return Auth.auth()
    }
    private var db = Database.database().reference()
    
    private var storage = Storage.storage()
    
    func signed() -> Bool {
        return self.auth.currentUser != nil
        
    }
    
    func signUp(fullName: String, email: String, password: String, profilePhotoURL: String, errorHandler: @escaping ((_ error: Error?)->())) {
        
        auth.createUser(withEmail: email, password: password) { [weak self] (result, error) in
            guard let uid = result?.user.uid, error == nil else {
                errorHandler(error)
                return
            }
            ServiceManager.shared.createUserDb(name: fullName, email: email, photoURL: profilePhotoURL, uid: uid) { (result) in
                switch result {
                case .success(let response):
                    errorHandler(nil)
                    break
                case .failure(let err):
                    errorHandler(err)
                }
            }
            CurrentUser.shared.user = UserModel(uid: uid, fullName: fullName, email: email, profilePhotoURL: profilePhotoURL)
            
        }
    }
    
    func signIn(email: String, password: String, errorHandler: @escaping ((_ error: Error?)->())) {
        auth.signIn(withEmail: email, password: password) { (result, error) in
            guard let uid = result?.user.uid, error == nil else {
                errorHandler(error)
                return
            }
            ServiceManager.shared.fetchUserInfos(uid: uid) { (result) in
                switch result {
                case .success(let response):
                    CurrentUser.shared.user = response
                    errorHandler(nil)
                    break
                case .failure(let error):
                    errorHandler(error)
                    break
                }
            }
        }
    }
    
    func signOut() -> Bool {
        do {
            try auth.signOut()
            return true
        } catch {
            return false
        }
        
    }
    
    func uploadImagePic(img1: UIImage,barcode: String, urlCompletion: ((_ downUrl: URL?)->())? = nil) {
        
        if let data = img1.jpegData(compressionQuality: 0.5) {
            // set upload path
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            let photoRef = self.storage.reference().child("images").child("products").child("\(barcode).jpeg")
            photoRef.putData(data, metadata: metaData) { (metadata, error) in
                if error == nil {
                    photoRef.downloadURL { (url, error) in
                        if error == nil {
                            urlCompletion?(url)
                            
                        } else { urlCompletion?(nil) }
                    }
                } else { urlCompletion?(nil) }
            }
            
            
        } else { urlCompletion?(nil) }
        
        
        
    }
    
    func uploadTag(img1: UIImage, urlCompletion: ((_ downUrl: URL?)->())? = nil) {
        
        if let data = img1.jpegData(compressionQuality: 0.5) {
            // set upload path
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            let photoRef = self.storage.reference().child("images").child("price_tags").child("\(UUID().uuidString)-\(Date())-iOS.jpeg")
            photoRef.putData(data, metadata: metaData) { (metadata, error) in
                if error == nil {
                    photoRef.downloadURL { (url, error) in
                        if error == nil {
                            urlCompletion?(url)
                            
                        } else { urlCompletion?(nil) }
                    }
                } else { urlCompletion?(nil) }
            }
            
            
        } else { urlCompletion?(nil) }
        
        
        
    }
    
}


class CurrentUser {
    private init() { }
    static let shared = CurrentUser()
    
    var user: UserModel?
}

struct UserModel: Codable {
    var uid: String
    var fullName: String
    var email: String
    var profilePhotoURL: String
    
    enum CodingKeys: String, CodingKey {
        
        case uid = "uid"
        case fullName = "name"
        case profilePhotoURL = "profilePhotoURL"
        case email = "email"
        
    }
}

