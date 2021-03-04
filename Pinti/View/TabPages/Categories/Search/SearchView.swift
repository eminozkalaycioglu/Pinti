//
//  SearchView.swift
//  Pinti
//
//  Created by Emin on 4.01.2021.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = SearchViewModel()
    @State var searchText: String = ""
    @State var selectedProduct: Product?
    @State var presentDetail: Bool = false
    var body: some View {
        ZStack {
            Color.init(hex: Constants.shared.appBgColor)
                .edgesIgnoringSafeArea(.all) //app bg
            
            CustomNavigationBar(style: .search, searchText: self.$searchText, showBackButton: true, {
                ZStack {
                    ProductsGridView(products: self.viewModel.products) { (product) in
                        self.selectedProduct = product
                        self.presentDetail.toggle()
                    }
                    if self.viewModel.products.count == 0 {
                        if self.searchText.count == 0 {
                            Text("Anahtar kelime giriniz")
                                .foregroundColor(.grayTextColor)
                                .poppins(.extraBold, 24)
                        } else {
                            Text("Ürün bulunamadı!")
                                .foregroundColor(.grayTextColor)
                                .poppins(.extraBold, 24)
                        }
                        
                    }
                }
                
            }, dismiss: {
                self.presentationMode.wrappedValue.dismiss()
            })
            
            
            
        }.onChange(of: self.searchText, perform: { value in
            if value.count > 0 {
                self.viewModel.search(query: value)

            } else {
                self.viewModel.products = []
            }
        })
        .navigate(to: ProductDetailView(product: self.selectedProduct ?? Product(categoryId: "", barcode: "", photoURL: "", name: "", brand: "", records: [])), when: self.$presentDetail)
        .hideNavigationBar()
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
