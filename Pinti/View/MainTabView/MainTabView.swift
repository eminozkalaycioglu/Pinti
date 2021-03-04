//
//  MainTabView.swift
//  Pinti
//
//  Created by Emin on 16.12.2020.
//

import SwiftUI

struct MainTabView: View {
    @State private var tabSelection = 0
    init() {
        UITabBar.appearance().backgroundColor = .white

    }
    
    var body: some View {
        
        TabView(selection: self.$tabSelection, content:  {
            
            HomepageView().tabItem {
                Image("home30")
                    .renderingMode(.template)
                    .foregroundColor(.gray)
                    
                Text("Anasayfa")
            }.tag(0)
            CategoriesView().tabItem {
                Image(systemName: "magnifyingglass")
                    .renderingMode(.template)
                    .foregroundColor(.gray)
                Text("Kategoriler")
                
            }.tag(1)
            AddProductView().tabItem {
                Image(systemName: "plus")
                    .renderingMode(.template)
                    .foregroundColor(.gray)
                Text("Ürün Ekle")
            }.tag(2)
            UserProfileView().tabItem {
                Image(systemName: "person.fill")
                    .renderingMode(.template)
                    .foregroundColor(.gray)
                
                Text("Profil")
                
            }.tag(3)
            
        }).accentColor(Color.init(hex: Constants.shared.tabBarAccentColor))
        .hideNavigationBar()
        
        
        
        
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
