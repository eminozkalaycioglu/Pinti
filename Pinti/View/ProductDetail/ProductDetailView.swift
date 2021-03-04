//
//  ProductDetailView.swift
//  Pinti
//
//  Created by Emin on 27.12.2020.
//

import SwiftUI
import struct Kingfisher.KFImage

struct ProductDetailView: View {
    @ObservedObject var viewModel = ProductDetailViewModel()
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var categoriesAndShops: CategoriesAndShops
    
    var product: Product
    
    var body: some View {
        ZStack {
            Color.init(hex: Constants.shared.appBgColor)
                .edgesIgnoringSafeArea(.all) //app bg
                
            
            CustomNavigationBar(showBackButton: true) {
                ScrollView {
                    VStack {
                        HStack {
                            Spacer()
                            VStack {
                                if let urlString = self.product.photoURL, let url = URL(string: urlString) {
                                    KFImage(url)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 300, alignment: .center)
                                        .padding(.top, 8)
                                }
                                Text(product.name ?? "")
                                    .poppins(.bold, 24)
                                    .padding(.bottom, 4)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.grayTextColor)
                                HStack(spacing: 0) {
                                    Text(product.brand ?? "")
                                        .poppins(.regular, 12)
                                        .foregroundColor(Color.grayTextColor)
                                    
                                    
                                    
                                    if let categoryId = self.product.categoryId, let categoryName = self.categoriesAndShops.findCategoryName(by: categoryId) {
                                        Text(" - \(categoryName)")
                                            .poppins(.regular, 12)
                                            .foregroundColor(Color.grayTextColor)
                                        
                                    }
                                    
                                    
                                }
                                
                                
                            }.padding(.bottom)
                            
                            Spacer()
                        }
                        .background(Color.white.cornerRadius(6))
                        .padding([.top,.horizontal], 8)
                        
                        
                        
                        
                        LazyVGrid(columns: [GridItem(.flexible())], content: {
                            
                            if let records = product.records {
                                ForEach(records, id: \.self) { record in
                                    DetailRecordCell(record: record)
                                }
                            }
                            
                        })
                        
                    }
                    
                }
            } dismiss: {
                self.presentationMode.wrappedValue.dismiss()
            }
        }.hideNavigationBar()
    }
    
    
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HomepageView().environmentObject(CategoriesAndShops())
    }
}

