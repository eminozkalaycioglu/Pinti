//
//  SignUpView.swift
//  Pinti
//
//  Created by Emin on 8.12.2020.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel = SignUpViewModel()
    @State var email: String?
    @State var name: String?

    @State var password: String?
    @State var passwordAgain: String?

    @State var presentSignIn: Bool = false
    
    var body: some View {
        
        ZStack {
            Color.init(hex: Constants.shared.appBgColor)
                .edgesIgnoringSafeArea(.all) //app bg

            CustomNavigationBar(showBackButton: false, {
                
                ScrollView {
                    VStack {
                        
                        VStack {
                            
                            Text("Kaydol")
                                .poppins(.bold, 30)
                                .foregroundColor(.grayTextColor)
                            
                            FloatingTextField(currentText: self.$name, "Ad Soyad", "", imageName: "person")
                                .padding([.top, .horizontal])

                            FloatingTextField(currentText: self.$email, "E-mail", "", imageName: "envelope")
                                .padding([.top, .horizontal])

                            FloatingTextField(currentText: self.$password, "Şifre", "", imageName: "mappin", secureText: true)
                                .padding([.top, .horizontal])

                            
                            FloatingTextField(currentText: self.$passwordAgain, "Şifre Tekrar", "", imageName: "mappin", secureText: true)
                                .padding([.top, .horizontal])

                            Button(action: {
                                
                                if self.password != self.passwordAgain {
                                    self.viewModel.presentErrorAlert = true
                                    self.viewModel.errorMessage = "Girdiğiniz şifreler uyuşmuyor"
                                    return
                                }
                                
                                guard let email = self.email, let name = self.name, let password = self.password else {
                                    self.viewModel.presentErrorAlert = true
                                    self.viewModel.errorMessage = "Alanları kontrol ediniz"
                                    return
                                }
                                self.viewModel.signUp(fullName: name, email: email, password: password, profilePhotoURL: "https://www.google.com")
                                
                            }, label: {
                                Text("Kaydol")
                                    .poppins(.semiBold, 16)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 12)
                                    .background(Color.pintiOrange.cornerRadius(4))
                            }).padding()
                            
                            HStack(spacing: 0) {
                                Text("Zaten bir hesabınız var mı? ")
                                    .poppins(.regular, 14)
                                    .foregroundColor(.grayTextColor)
                                
                                Button(action: {
                                    self.presentSignIn = true
                                }, label: {
                                    Text("Oturum Aç")
                                        .foregroundColor(.pintiOrange)
                                        .poppins(.regular, 15)
                                    
                                })
                            }
                            
                        }
                        .padding(.bottom)
                        .padding(8)
                        
                    }.padding(.vertical, 8)
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                    }
                }
            }, dismiss: nil)
            
            NavigationLink(
                destination: ContentView(),
                isActive: self.$viewModel.presentContent,
                label: {
                    Text("")
                })
            NavigationLink(
                destination: SignInView(),
                isActive: self.$presentSignIn,
                label: {
                    Text("")
                })

        }
        .alert(isPresented: self.$viewModel.presentErrorAlert, content: {
            Alert(title: Text("Hata!"), message: Text(self.viewModel.errorMessage ?? ""), dismissButton: .default(Text("Tamam")))
        })
        .hideNavigationBar()
        
    }
    
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
