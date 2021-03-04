//
//  CustomNavigationBar.swift
//  Pinti
//
//  Created by Emin on 17.12.2020.
//

import SwiftUI

enum NavStyle {
    case homepage(backButton: Bool)
    case other(title: String, backButton: Bool)
    case search
}
struct NavigationBarView: View {
    @Binding var searchText: String
    var style: NavStyle
    var dismiss: (()->())?
    var searchButtonTapped: (()->())?
    var showSearchButton: Bool
    var body: some View {
        ZStack {

            Color.pintiOrange
                .frame(height: 60, alignment: .center)

            switch self.style {
            case .other(let title, let backButton):

                ZStack {
                    HStack {
                        Spacer()
                        Text(title)
                            .foregroundColor(.white)
                            .poppins(.semiBold, 18)
                        Spacer()

                    }

                    if backButton {
                        HStack {
                            Button(action: {
                                self.dismiss?()
                            }, label: {
                                Image(systemName: "arrow.left").renderingMode(.template).foregroundColor(.white)
                            })

                            Spacer()
                        }.padding()
                    }
                }

            case .homepage(let backButton):
                
                ZStack {
                    HStack {
                        Spacer()
                        Image("pintiLogo").resizable().scaledToFit().frame(height: 30)
                        Spacer()

                    }

                    HStack {
                        if backButton {
                            Button(action: {
                                self.dismiss?()
                            }, label: {
                                Image(systemName: "arrow.left")
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                            })
                            
                        }
                        Spacer()
                        if self.showSearchButton {
                            Button(action: {
                                self.searchButtonTapped?()
                            }, label: {
                                Image(systemName: "magnifyingglass")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    
                                    .frame(width: 20, height: 20, alignment: .center)
                            })
                            
                        }
                        
                        
                    }.padding()
                    
                }
                
            case .search:
                
                ZStack {
                    
                    

                    HStack {
                        Button(action: {
                            self.dismiss?()
                        }, label: {
                            Image(systemName: "arrow.left")
                                .renderingMode(.template)
                                .foregroundColor(.white)
                        })
                        
                        HStack {
                            TextField("Ürün Ara...", text: self.$searchText)
                                .padding(10)
                                .foregroundColor(Color.black.opacity(0.5))
                                .font(.custom("Poppins-Medium", size: 16))
                                
                            Image(systemName: "xmark")
                                .renderingMode(.template)
                                .foregroundColor(Color.black.opacity(0.3))
                                .onTapGesture {
                                    self.searchText = ""
                                }
                                .padding()
                        }.background(Color.black.opacity(0.1).cornerRadius(5))
                        .padding(.leading, 8)
                        
                        Spacer()
                        
                        
                        
                    }.padding(.horizontal)
                    
                }
                
            }


        }
        
    }
}

struct NavigationBarView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBarView(searchText: .constant("SearchText"), style: .search, showSearchButton: false)
        
    }
}

struct CustomNavigationBar<Content>: View where Content: View {
    @Binding var searchText: String
    let content: () -> Content
    var showBackButton: Bool
    var dismiss: (()->())?
    var searchButtonTapped: (()->())?
    var showSearchButton: Bool
    var style: NavStyle
    init(style: NavStyle? = nil,searchText: Binding<String>? = nil,showBackButton: Bool, @ViewBuilder _ content: @escaping () -> Content, dismiss: (()->())?, showSearchButton: Bool = false, searchButtonTapped: (()->())? = nil) {
        self.content = content
        self.showBackButton = showBackButton
        self.dismiss = dismiss
        self.showSearchButton = showSearchButton
        self.searchButtonTapped = searchButtonTapped
        self._searchText = searchText ?? .constant("Search")
        self.style = style ?? .homepage(backButton: showBackButton)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { gp in
                Color.pintiOrange.frame(height: gp.safeAreaInsets.top).edgesIgnoringSafeArea(.top)
            }.frame(height: 0) // status bar
            NavigationBarView(searchText: self.$searchText, style: self.style, dismiss: self.dismiss,searchButtonTapped: self.searchButtonTapped, showSearchButton: self.showSearchButton)
            
            content()
            Spacer()
        }
    }
    
    
    
}
