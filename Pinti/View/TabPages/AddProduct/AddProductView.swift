//
//  AddProductView.swift
//  Pinti
//
//  Created by Emin on 16.12.2020.
//

import SwiftUI

struct AddProductView: View {
    @State var isPresentingScanner = false
    @State var scannedCode: String?
    @State var presentAddRecord = false
    var body: some View {
        ZStack {
            Color.init(hex: Constants.shared.appBgColor)
                .edgesIgnoringSafeArea(.all) //app bg

//            CustomNavigationBar(showBackButton: false) {
//
//            } dismiss: {}
            CustomNavigationBar(showBackButton: false, {
                VStack {
                    Image("addBarcode")
                        .resizable()
                        .scaledToFit()
                    Text("Barkod Tara")
                        .poppins(.semiBold, 18)
                        .foregroundColor(.grayTextColor)
                    Text("Fiyat bilgisi eklemek veya yeni bir ürün oluşturmak için lütfen barkodu tarayınız.")
                        .poppins(.light, 12)
                        .padding(.bottom, 6)
                        .padding(.top, 2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.grayTextColor)
                    
                    

                        
                }
                .background(Color.white.cornerRadius(6))
                .padding(8)
                .onTapGesture {
                    self.isPresentingScanner = true
                }
                
            }, dismiss: nil, showSearchButton: false, searchButtonTapped: nil)
            
        }
        .sheet(isPresented: $isPresentingScanner) {
            self.scannerSheet
        }
        
        .navigate(to: AddRecordView(barcode: self.scannedCode ?? ""), when: self.$presentAddRecord)
        .hideNavigationBar()
    }
    
    var scannerSheet : some View {
        CodeScannerView(
            codeTypes: [.ean13],
            completion: { result in
                if case let .success(code) = result {
                    self.scannedCode = code
                    self.isPresentingScanner = false
                    if code.count > 0 {
                        self.presentAddRecord = true
                    }
                }
            }
        )
    }
}

struct AddProductView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductView()
    }
}
