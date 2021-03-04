//
//  CustomProgressView.swift
//  Pinti
//
//  Created by Emin on 7.01.2021.
//

import Foundation
import SwiftUI

struct CustomProgressView: View {
    
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Color.init(.black)
                .opacity(0.5)
                
            ProgressView("Yükleniyor")
                .padding()
                .background(Color.white.cornerRadius(6))
                .shadow(radius: 10)
            
        }.edgesIgnoringSafeArea(.all)
        
    }
    
    func foreverAnimation(duration: Double) -> Animation {
        return Animation.linear(duration: duration)
            .repeatForever(autoreverses: false)
    }
    
    
}



struct asd: PreviewProvider {
    static var previews: some View {
        CustomProgressView()
        
    }
}
