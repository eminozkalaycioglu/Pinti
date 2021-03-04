//
//  UserProfileViewModel.swift
//  Pinti
//
//  Created by Emin on 7.01.2021.
//

import Foundation
import Combine

class UserProfileViewModel: ObservableObject {
    
    @Published var presentSignIn = false
    func signOut() {
        if FirebaseManager.shared.signOut() {
            self.presentSignIn = true
        }
    }
}
