//
//  FilteredProductsView.swift
//  Pinti
//
//  Created by Emin on 1.01.2021.
//

import SwiftUI


struct FilteredProductsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var viewModel: FilteredProductsViewModel
    
    @State var presentDetail = false
    @State var selectedProduct: Product?
    
    init(categoryId: String? = nil, shopId: String? = nil) {
        self.viewModel = FilteredProductsViewModel(categoryId: categoryId, shopId: shopId)
    }
    
    var body: some View {
        ZStack {
            Color.init(hex: Constants.shared.appBgColor)
                .edgesIgnoringSafeArea(.all) //app bg

            CustomNavigationBar(showBackButton: true) {
                ProductsGridView(products: self.viewModel.filteredProducts) { (product) in
                    self.selectedProduct = product
                    self.presentDetail.toggle()
                }.padding(.vertical)
            } dismiss: {
                self.presentationMode.wrappedValue.dismiss()
            }
            if self.viewModel.loading {
                CustomProgressView()
            }

            
        }.navigate(to: ProductDetailView(product: self.selectedProduct ?? Product(categoryId: "", barcode: "", photoURL: "", name: "", brand: "", records: [])), when: self.$presentDetail)
        .hideNavigationBar()
    }
}

struct FilteredProductsView_Previews: PreviewProvider {
    static var previews: some View {
        FilteredProductsView()
    }
}
