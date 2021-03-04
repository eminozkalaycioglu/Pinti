//
//  FilterContentView.swift
//  Pinti
//
//  Created by Emin on 1.01.2021.
//

import SwiftUI
import struct Kingfisher.KFImage

enum FilterType: Int {
    case Category = 0
    case Shop = 1
}
struct FilterContentView: View {
    @EnvironmentObject private var categoriesAndShops: CategoriesAndShops
    
    var type: FilterType
    
    var cellTapped: ((FilterType, String)->())?
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: [
                    GridItem(.flexible(minimum: 100, maximum: 200)),
                    GridItem(.flexible(minimum: 100, maximum: 200)),
                    GridItem(.flexible(minimum: 100, maximum: 200))
                ], content: {
                    switch self.type {
                    case .Category:
                        ForEach(self.categoriesAndShops.categories, id: \.self) { category in
                            FilterTypeCell(category: category).onTapGesture {
                                if let categoryId = category.categoryId {
                                    self.cellTapped?(.Category, categoryId)
                                    
                                }
                               
                            }
                        }
                    case .Shop:
                        ForEach(self.categoriesAndShops.shops, id: \.self) { shop in
                            FilterTypeCell(shop: shop).onTapGesture {
                                if let shopId = shop.shopId {
                                    self.cellTapped?(.Shop, shopId)
                                }
                            }
                        }
                    }
                    
                    
                })
            }
        }
    }
}

struct FilterContentView_Previews: PreviewProvider {
    static var previews: some View {
        FilterContentView(type: .Shop).environmentObject(CategoriesAndShops())
    }
}

struct FilterTypeCell: View {
    var category: Category? = nil
    var shop: Shop? = nil
    @State var showDefault = false
    var body: some View {
        VStack {
            if let shop = self.shop, let url = URL(string: shop.photoURL ?? "") {
                Spacer()

                if self.showDefault {
                    Image("defaultImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width/3 - 30, height: UIScreen.main.bounds.width/3 - 30, alignment: .center)

                } else {
                    KFImage(url)
                        .resizable()
                        .onFailure(perform: { (error) in
                            self.showDefault = true
                        })
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width/3 - 30, height: UIScreen.main.bounds.width/3 - 30, alignment: .center)
                }
                
                Spacer()
                Text(shop.shopName ?? "")
                    .poppins(.bold, 12)
                    .foregroundColor(Color.grayTextColor)
                
            }
            
            if let category = self.category, let url = URL(string: category.categoryPhotoURL ?? "") {
                Spacer()

                if self.showDefault {
                    Image("defaultImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width/3 - 30, height: UIScreen.main.bounds.width/3 - 30, alignment: .center)

                }
                else {
                    KFImage(url)
                        .resizable()
                        .onFailure(perform: { (error) in
                            self.showDefault = true
                        })
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width/3 - 30, height: UIScreen.main.bounds.width/3 - 30, alignment: .center)
                }
                
                Spacer()
                Text(category.categoryName ?? "")
                    .poppins(.bold, 12)
                    .foregroundColor(Color.grayTextColor)

            }
        }.frame(height: 120, alignment: .center)
        .padding(8)
        .padding(.vertical, 6)
        .background(Color.white.cornerRadius(6))
        
    }
}

//struct FilterTypeCell_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterTypeCell(shop: Shop(photoURL: "https://i.pinimg.com/originals/f2/de/b3/f2deb32dc6cd0bcc8eb417f97e4b2540.png", shopId: "", shopName: "A101"))
//    }
//}
