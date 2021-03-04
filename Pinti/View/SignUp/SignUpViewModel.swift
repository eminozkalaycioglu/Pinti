//
//  SignUpViewModel.swift
//  Pinti
//
//  Created by Emin on 8.12.2020.
//

import Foundation
import Combine

class SignUpViewModel: ObservableObject {
    
    
    @Published var presentErrorAlert: Bool = false
    @Published var presentContent: Bool = false
    var errorMessage: String?
    func signUp(fullName: String, email: String, password: String, profilePhotoURL: String) {
        FirebaseManager.shared.signUp(fullName: fullName, email: email, password: password, profilePhotoURL: profilePhotoURL) { (error) in
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.presentErrorAlert = true
                print("emintest: error")
            } else {
                self.presentContent = true
                print("emintest: present")
            }
        }
    }
}
