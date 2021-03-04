//
//  PintiApp.swift
//  Pinti
//
//  Created by Emin on 5.12.2020.
//

import SwiftUI
import Firebase
import Bagel

@main
struct PintiApp: App {
    init() {
        FirebaseApp.configure()
        Bagel.start()
        
        if let uid = FirebaseManager.shared.auth.currentUser?.uid {
            ServiceManager.shared.fetchUserInfos(uid: uid) { (result) in
                switch result {
                case .success(let response):
                    CurrentUser.shared.user = response
                case .failure(let error):
                    break
                }
            }
        }
        
    }
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(CategoriesAndShops())
        }
    }
    
}
