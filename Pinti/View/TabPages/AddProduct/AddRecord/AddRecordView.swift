//
//  AddRecordView.swift
//  Pinti
//
//  Created by Emin on 2.01.2021.
//

import SwiftUI
import struct Kingfisher.KFImage
struct AddRecordView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AddRecordViewModel
    @EnvironmentObject var categoriesAndShops: CategoriesAndShops
    @StateObject var locManager = LocationManager()

    
    @State var captureProductImage: Bool = false
    @State var productImage = UIImage(named: "productPhoto")!
    @State var capturePriceImage: Bool = false
    @State var priceImage = UIImage(named: "pricePhoto")!
    @State var shopName: String?
    @State var price: String?
    @State var selectedShopName = ""
    
    var barcode: String
    
    init(barcode: String) {
        self.barcode = barcode
        self.viewModel = AddRecordViewModel(barcode: barcode)
    }
    var body: some View {
        ZStack {
            Color.init(hex: Constants.shared.appBgColor)
                .edgesIgnoringSafeArea(.all) //app bg

            CustomNavigationBar(showBackButton: true, {
                if self.viewModel.exist {
                    self.contentFound
                } else {
                    self.contentNotFound

                }
              
            }, dismiss: {
                self.presentationMode.wrappedValue.dismiss()
            })
            
            if self.captureProductImage {
                CaptureImageView(isShown: self.$captureProductImage, image: self.$productImage)
            }
            
            if self.capturePriceImage {
                CaptureImageView(isShown: self.$capturePriceImage, image: self.$priceImage)
            }
            
            if self.viewModel.loading {
//                Color.gray.opacity(0.5).edgesIgnoringSafeArea(.all)
//                ProgressView("Yükleniyor...")
                
//                CustomProgressView()

            }
        }.onAppear() {
            self.selectedShopName = self.categoriesAndShops.shops.first?.shopName ?? ""
            
        }.onReceive(self.viewModel.$addSuccess, perform: { newVal in
            if newVal {
                self.presentationMode.wrappedValue.dismiss()
            }
        })
        .hideNavigationBar()
        
    }
    
    @State var productName: String?
    @State var productBrand: String?
    @State var selectedCategoryName: String?
    var contentNotFound: some View {
        
        ScrollView {
            VStack {
                HStack {
                    VStack {
                        Image(uiImage: self.productImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: UIScreen.main.bounds.width/2 - 30, maxHeight: 120)
                            .padding(.trailing, 8)
                        Text("Fotoğraf Ekle")
                            .poppins(.semiBold, 14)
                    }
                    .padding([.vertical, .leading],8)
                    .background(Color.white.cornerRadius(6))
                    .onTapGesture {
                        self.captureProductImage = true
                    }
                    
                    ZStack {
                        VStack {
                            Image(uiImage:self.priceImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: UIScreen.main.bounds.width/2 - 30, maxHeight: 120)
                                .padding(.leading, 8)
                                .onChange(of: self.priceImage, perform: { value in
                                    self.viewModel.hideContent = false
                                    print("emintest: cahn")
                                    self.viewModel.uploadPriceTag(img: value)

                                })

                            Text("Etiket Tara")
                                .poppins(.semiBold, 14)
                        }.padding([.vertical, .trailing],8)
                        .background(Color.white.cornerRadius(6))
                        .onTapGesture {
                            self.capturePriceImage = true

                        }
                        if self.viewModel.loading {
                            ProgressView("Fiyat Algılanıyor")
                                .padding()
                                .background(Color.white.cornerRadius(6))
                                .shadow(radius: 10)
                        }
                    }
                    
                }
                
                VStack {
                    FloatingTextField(currentText: self.$productName,"Ürün Adı", "Ürün Adı")
                        .padding([.top, .horizontal])
                    
                    FloatingTextField(currentText: self.$productBrand, "Marka", "Marka")
                        .padding([.top, .horizontal])

                    
       
                    
                    Menu {
                        
                        ForEach(self.categoriesAndShops.categories, id: \.self) { cat in
                            Button(action: {
                                self.selectedCategoryName = cat.categoryName
                            }, label: {
                                Text("\(self.categoriesAndShops.findCategoryName(by: cat.categoryId ?? "0") ?? "MARKET")")
                                    .poppins(.bold, 16)
                            })
                        }
                    } label: {
                        
                        FloatingTextField("Kategori", "Kategori", defaultValue: self.selectedCategoryName, disabled: true)
                            .padding([.top, .horizontal])
                        
                    }
                    
                    Menu {
                        
                        ForEach(self.categoriesAndShops.shops, id: \.self) { shop in
                            Button(action: {
                                self.selectedShopName = shop.shopName ?? "MARKET"
                            }, label: {
                                Text("\(self.categoriesAndShops.findShopName(by: shop.shopId ?? "0") ?? "MARKET")")
                                    .poppins(.bold, 16)
                            })
                        }
                    } label: {
                        FloatingTextField("Market", "Market", defaultValue: self.selectedShopName, disabled: true)
                            .padding([.top, .horizontal])
                    }
                    
                    FloatingTextField("Konum", "Ürün Adı", defaultValue: self.locManager.address ?? "Bulunamadı!", disabled: true)
                        .padding([.top, .horizontal])

                    FloatingTextField(currentText: self.$price, "Fiyat", "")
                        .padding([.top, .horizontal])
                    
                    
                    Button(action: {
                        if let brand = self.productBrand,
                           brand.count > 2,
                           let categoryId = self.categoriesAndShops.findCategoryId(by: self.selectedCategoryName ?? ""),
                           let name = self.productName, name.count > 2 {
                            self.viewModel.addProduct(barcode: self.barcode, brand: brand, categoryId: categoryId, productPhoto: self.productImage, name: name) {
                                
                                if let shopId = self.categoriesAndShops.findShopId(by: self.selectedShopName),
                                   let price = Double(self.price ?? ""){
                                    self.viewModel.addRecord(barcode: self.barcode, shopId: shopId, price: price, locationTitle: self.locManager.address ?? "", locationCoordinate: self.locManager.locationString)

                                }
                            }
                        }
                        
                        
                        
                    }, label: {
                        Text("Kaydet")
                            .poppins(.semiBold, 16)
                            .foregroundColor(.white)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(Color.pintiOrange.cornerRadius(4))
                    }).padding()
                   
                }
                .padding(.bottom)
                .background(Color.white.cornerRadius(6))
                .padding(8)
                .isHidden(self.viewModel.hideContent)

            
                
            }.padding(.vertical, 8)
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
        }
        
    }
    
    
    var contentFound: some View {
        ScrollView {
            VStack {
                HStack {
                    VStack {
                        if let urlStr = self.viewModel.product.first?.photoURL, let url = URL(string: urlStr) {
                            KFImage(url)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: UIScreen.main.bounds.width/2 - 30,minHeight: 90, maxHeight: 120)
                                
                                .padding(.trailing, 8)
                        }
                        
                        Text("Fotoğraf Eklendi")
                            .poppins(.semiBold, 14)
                    }
                    .padding([.vertical, .leading],8)
                    .background(Color.white.cornerRadius(6))
                    
                    ZStack {
                        VStack {
                            Image(uiImage:self.priceImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: UIScreen.main.bounds.width/2 - 30,minHeight: 90, maxHeight: 120)
                                .padding(.leading, 8)
                                .onChange(of: self.priceImage, perform: { value in
                                    self.viewModel.hideContent = false
                                    print("emintest: cahn")
                                    self.viewModel.uploadPriceTag(img: value)
                                })

                            Text("Etiket Tara")
                                .poppins(.semiBold, 14)
                        }.padding([.vertical, .trailing],8)
                        .background(Color.white.cornerRadius(6))
                        .onTapGesture {
                            self.capturePriceImage = true

                        }
                        
                        if self.viewModel.loading {
                            ProgressView("Fiyat Algılanıyor")
                                .padding()
                                .background(Color.white.cornerRadius(6))
                                .shadow(radius: 10)
                        }
                    }
                    
                }
                
                VStack {
                    FloatingTextField("Ürün Adı", "Ürün Adı", defaultValue: self.viewModel.product.first?.name ?? "", disabled: true)
                        .padding([.top, .horizontal])
                    
                    FloatingTextField("Marka", "Marka", defaultValue: self.viewModel.product.first?.brand ?? "", disabled: true)
                        .padding([.top, .horizontal])

                    FloatingTextField("Kategori", "Kategori", defaultValue: self.categoriesAndShops.findCategoryName(by: self.viewModel.product.first?.categoryId ?? "0") ?? "", disabled: true)
                        .padding([.top, .horizontal])
       
                    Menu {
                        
                        ForEach(self.categoriesAndShops.shops, id: \.self) { shop in
                            Button(action: {
                                self.selectedShopName = shop.shopName ?? "MARKET"
                            }, label: {
                                Text("\(self.categoriesAndShops.findShopName(by: shop.shopId ?? "0") ?? "MARKET")")
                                    .poppins(.bold, 16)
                            })
                        }
                    } label: {
                        FloatingTextField("Market", "Market", defaultValue: self.selectedShopName, disabled: true)
                            .padding([.top, .horizontal])
                    }
                    
                    FloatingTextField("Konum", "Ürün Adı", defaultValue: self.locManager.address ?? "Bulunamadı!", disabled: true)
                        .padding([.top, .horizontal])

                    FloatingTextField(currentText: self.$price, "Fiyat", "")
                        .padding([.top, .horizontal])
                    
                    
                    
                    Button(action: {
                        if let shopId = self.categoriesAndShops.findShopId(by: self.selectedShopName), let price = Double(self.price ?? "") {
                            self.viewModel.addRecord(barcode: self.barcode, shopId: shopId, price: price, locationTitle: self.locManager.address ?? "", locationCoordinate: self.locManager.locationString)
                        }
                        
                    }, label: {
                        Text("Kaydet")
                            .poppins(.semiBold, 16)
                            .foregroundColor(.white)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(Color.pintiOrange.cornerRadius(4))
                    }).padding()
                   
                }
                .padding(.bottom)
                .background(Color.white.cornerRadius(6))
                .padding(8)
                .isHidden(self.viewModel.hideContent)
                
                
            }.padding(.vertical, 8)
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .onReceive(self.viewModel.$price, perform: { newVal in
                print("emintest: published change")
                self.price = newVal
            })
        }
        
    }
}

struct AddRecordView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecordView(barcode: "1ad00").environmentObject(CategoriesAndShops())
    }
}


