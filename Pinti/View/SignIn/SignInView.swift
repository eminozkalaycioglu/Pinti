//
//  SignInView.swift
//  Pinti
//
//  Created by Emin on 8.12.2020.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var viewModel = SignInViewModel()
    @State var email: String?

    @State var password: String?

    @State var presentSignUp: Bool = false
    var body: some View {
        ZStack {
            Color.init(hex: Constants.shared.appBgColor)
                .edgesIgnoringSafeArea(.all) //app bg

            CustomNavigationBar(showBackButton: false, {
                Spacer()

                VStack {
                    VStack {
                        Text("Oturum Aç")
                            .poppins(.bold, 30)
                            .foregroundColor(.grayTextColor)



                        FloatingTextField(currentText: self.$email, "E-mail", "", imageName: "envelope")
                            .padding([.top, .horizontal])

                        FloatingTextField(currentText: self.$password, "Şifre", "", imageName: "mappin", secureText: true)
                            .padding([.top, .horizontal])




                        Button(action: {



                            guard let email = self.email, let password = self.password else {
                                self.viewModel.presentErrorAlert = true
                                self.viewModel.errorMessage = "Alanları kontrol ediniz"
                                return
                            }
                            self.viewModel.signIn(email: email, password: password)

                        }, label: {
                            Text("Oturum Aç")
                                .poppins(.semiBold, 16)
                                .foregroundColor(.white)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(Color.pintiOrange.cornerRadius(4))
                        }).padding()

                        HStack(spacing: 0) {
                            Text("Hesabınız yok mu? ")
                                .poppins(.regular, 14)
                                .foregroundColor(.grayTextColor)

                            Button(action: {
                                self.presentSignUp = true
                            }, label: {
                                Text("Kaydol")
                                    .foregroundColor(.pintiOrange)
                                    .poppins(.regular, 15)

                            })
                        }



                    }
                    .padding(.bottom)
                    .padding(8)
                    .frame(height: 0)

                }.padding(.vertical, 8)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            }, dismiss: nil)
            
            NavigationLink(
                destination: ContentView(),
                isActive: self.$viewModel.presentContent,
                label: {
                    Text("")
                })
            NavigationLink(
                destination: SignUpView(),
                isActive: self.$presentSignUp,
                label: {
                    Text("")
                })

        }
        .alert(isPresented: self.$viewModel.presentErrorAlert, content: {
            Alert(title: Text("Hata!"), message: Text(self.viewModel.errorMessage ?? ""), dismissButton: .default(Text("Tamam")))
        })
        .hideNavigationBar()    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
