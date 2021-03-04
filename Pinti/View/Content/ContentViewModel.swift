//
//  ContentViewModel.swift
//  Pinti
//
//  Created by Emin on 5.12.2020.
//

import Foundation
import Combine
class ContentViewModel: ObservableObject {

    init() {
        
    }
    
    func signed() -> Bool {
        return FirebaseManager.shared.signed()
    }
    
    
}
