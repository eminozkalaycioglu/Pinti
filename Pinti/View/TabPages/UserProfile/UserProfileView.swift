//
//  UserProfileView.swift
//  Pinti
//
//  Created by Emin on 16.12.2020.
//

import SwiftUI
import MapKit

struct UserProfileView: View {
    @ObservedObject var viewModel = UserProfileViewModel()
    var body: some View {
        
        ZStack {
            Color.init(hex: Constants.shared.appBgColor)
                .edgesIgnoringSafeArea(.all) //app bg
            
            CustomNavigationBar(showBackButton: false, {
                HStack {
                    Spacer()
                    VStack {
                        
                        Text(CurrentUser.shared.user?.fullName ?? "FullName")
                            .poppins(.medium, 24)
                            .foregroundColor(.grayTextColor)
                        
                        Text(CurrentUser.shared.user?.email ?? "FullName")
                            .poppins(.regular, 18)
                            .foregroundColor(.grayTextColor)
                        
                        Button(action: {
                            
                            self.viewModel.signOut()
                            
                        }, label: {
                            Text("Çıkış Yap")
                                .poppins(.semiBold, 16)
                                .foregroundColor(.white)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(Color.pintiOrange.cornerRadius(4))
                        }).padding(10)
                        
                        
                    }
                    Spacer()
                }.padding(12)
                .background(Color.white.cornerRadius(6))
                .padding(8)
                
            }, dismiss: nil)
            
            
            NavigationLink(
                destination: ContentView(),
                isActive: self.$viewModel.presentSignIn,
                label: {
                    Text("")
                })
            
        }
        .hideNavigationBar()
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
