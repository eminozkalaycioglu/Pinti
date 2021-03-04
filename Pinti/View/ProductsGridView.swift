//
//  ProductsGridView.swift
//  Pinti
//
//  Created by Emin on 1.01.2021.
//

import SwiftUI

struct ProductsGridView: View {
    

    var products: [Product]
    
    var productTapped: ((Product)->())?
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .center, content: {
                ForEach(self.products, id: \.self) { product in
                    ProductCell(product: product).onTapGesture {
                        self.productTapped?(product)
                    }
                    
                }
            }).padding(.horizontal, 10)
            
            
        }.background(Color.clear)
        
    }
}
//
//struct ProductsGridView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductsGridView()
//    }
//}
