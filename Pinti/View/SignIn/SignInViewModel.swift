//
//  SignInViewModel.swift
//  Pinti
//
//  Created by Emin on 8.12.2020.
//

import Foundation
import Combine

class SignInViewModel: ObservableObject {
    
    @Published var presentErrorAlert: Bool = false
    @Published var presentContent: Bool = false
    var errorMessage: String?
    
    
    func signIn(email: String, password: String) {
        FirebaseManager.shared.signIn(email: email, password: password) { (error) in
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.presentErrorAlert = true
            } else {
                self.presentContent = true
            }
        }
        
    }
}
