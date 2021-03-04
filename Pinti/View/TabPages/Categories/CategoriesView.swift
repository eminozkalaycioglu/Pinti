//
//  CategoriesView.swift
//  Pinti
//
//  Created by Emin on 16.12.2020.
//

import SwiftUI

struct CategoriesView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var selectedTabIndex = 0
    
    @State var presentFilteredView = false
    @State var selectedCategoryId: String?
    @State var selectedShopId: String?
    @State var presentSearchView = false
    var body: some View {
        ZStack {
            Color.init(hex: Constants.shared.appBgColor)
                .edgesIgnoringSafeArea(.all) //app bg
            
            CustomNavigationBar(showBackButton: false, {
                VStack(alignment: .leading) {
                    SlidingTabView(selection: self.$selectedTabIndex, tabs: ["Kategoriler", "Marketler"], selectionBarColor: Color(hex: Constants.shared.segmentedSelectionColor))
                        .background(Color.pintiOrange)
                        .foregroundColor(.white)
                    
                    
                    FilterContentView(type: FilterType.init(rawValue: self.selectedTabIndex)!, cellTapped: { (type, id) in
                        switch type {
                        case .Category:
                            print("selected cat id: \(id)")
                            self.selectedCategoryId = id
                            self.selectedShopId = nil
                            self.presentFilteredView.toggle()
                        case .Shop:
                            self.selectedShopId = id
                            self.selectedCategoryId = nil
                            self.presentFilteredView.toggle()
                        }
                    })
                        .padding(.horizontal, 8)
                    Spacer()
                }
            }, dismiss: {
                self.presentationMode.wrappedValue.dismiss()
            }, showSearchButton: true, searchButtonTapped: {
                self.presentSearchView = true
            })
            
            
            
        }
        .navigate(to: FilteredProductsView(categoryId: self.selectedCategoryId, shopId: self.selectedShopId), when: self.$presentFilteredView)
        .navigate(to: SearchView(), when: self.$presentSearchView)
        .hideNavigationBar()
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}
