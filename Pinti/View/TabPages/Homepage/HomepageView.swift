//
//  HomepageView.swift
//  Pinti
//
//  Created by Emin on 16.12.2020.
//

import SwiftUI
extension View {
    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>) -> some View {
        NavigationView {
            ZStack {
                self.hideNavigationBar()
                NavigationLink(
                    destination: view
                        .hideNavigationBar(),
                    isActive: binding
                ) {
                    EmptyView()
                }
            }
        }
    }
}



struct HomepageView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = HomepageViewModel()
    @State var presentDetail = false
    @State var selectedProduct: Product?
    
    var body: some View {
        ZStack {
            Color.init(hex: Constants.shared.appBgColor)
                .edgesIgnoringSafeArea(.all) //app bg
            
            CustomNavigationBar(showBackButton: false) {
                HStack {
                    Color.gray.frame(height: 1)
                    Text("Son Eklenenler")
                        .foregroundColor(.gray)
                        .poppins(.light, 14)
                        .onAppear {
                            self.viewModel.fetchLastProducts()
                        }
                    
                    Color.gray.frame(height: 1)

                }.padding(8)
                
                
                
                if self.viewModel.products != nil {
                    ProductsGridView(products: self.viewModel.products!) { (selectedProduct) in
                        self.selectedProduct = selectedProduct
                        self.presentDetail.toggle()
                    }
                }
            } dismiss: {
                self.presentationMode.wrappedValue.dismiss()
            }
            if self.viewModel.loading {
                CustomProgressView()

            }
        }
        .navigate(to: ProductDetailView(product: self.selectedProduct ?? Product(categoryId: "", barcode: "", photoURL: "", name: "", brand: "", records: [])), when: self.$presentDetail)
        .hideNavigationBar()
        
    }
    
    
    
    
}

struct HomepageView_Previews: PreviewProvider {
    static var previews: some View {
        HomepageView()
    }
}


