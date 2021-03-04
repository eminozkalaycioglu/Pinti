//
//  ContentView.swift
//  Pinti
//
//  Created by Emin on 5.12.2020.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    
    
    var body: some View {
        
//        MainTabView()
//
        
        NavigationView {
            if self.viewModel.signed() {
                MainTabView()
            } else {
                SignUpView()
            }
        }.hideNavigationBar()
        


        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
