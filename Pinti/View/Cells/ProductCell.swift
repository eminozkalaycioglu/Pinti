//
//  ProductCell.swift
//  Pinti
//
//  Created by Emin on 18.12.2020.
//

import SwiftUI
import struct Kingfisher.KFImage


struct ProductCell: View {
    @EnvironmentObject var categoriesAndShops: CategoriesAndShops
    var product: Product
    
    var cellWidth = (UIScreen.main.bounds.width-24)/2
    var cellHeight = 250
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                if let urlString = self.product.photoURL, let url = URL(string: urlString) {
                    KFImage(url)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 120)
                        .padding(8)

                }

                
                if product.records?.count ?? 0 > 3 {
                    HStack {
                        Spacer()
                        Text("\(self.product.records?.count ?? 0) Fiyat")
                            .poppins(.medium, 12)
                            .foregroundColor(.white)
                            .padding(3)
                            .background(Color.orange.cornerRadius(5, corners: [.topLeft,.bottomLeft]))
                        
                    }
                }
            }
            
            

            Text("\(self.product.name ?? "")")
                .poppins(.medium, 12)
                .foregroundColor(Color.grayTextColor)
                .padding(.horizontal, 8)
                .lineLimit(1)
                .multilineTextAlignment(.center)
            
            LazyVStack(spacing: 4) {
                let records = self.product.records
                let sortedRecords = records?.sorted(by: {$0.price! < $1.price!})
                ForEach((sortedRecords?.prefix(3))!, id: \.self) { record in
                    PriceCell(color: ((sortedRecords?.firstIndex(of: record))! % 2 == 0 ? Color(hex: "FFEFD6") : Color(hex: "EBEBEB")), shopName: self.categoriesAndShops.findShopName(by: record.shopId ?? "") ?? "", price: Double(record.price ?? 0))
                }
                
            }
            .padding(.vertical, 6)
                
        }

        .frame(width: self.cellWidth,height: 270, alignment: .center)
        .background(Color.white.cornerRadius(6.0))
        

    }
    

}



//struct ProductCell_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductCell(product: Product(categoryId: "1", barcode: "100", photoURL: "", name: "sfgdfhfgdhdhdhg", brand: "afsrghdhtd", records: [Record(barcode: "23", price: 2, recordDate: "12.12.2020", shopId: "1", locationCoordinate: "", locationTitle: "df", ownerId: "1", ownerName: "sdgdg")]))
//    }
//}
//struct HomepageView_Previews2: PreviewProvider {
//    static var previews: some View {
//        HomepageView().environmentObject(CategoriesAndShops())
//    }
//}


struct PriceCell: View {
    @State var color: Color
    var shopName: String
    var price: Double
    var body: some View {
        HStack {
            Text(self.shopName)
                .poppins(.regular, 12)
                .foregroundColor(Color.grayTextColor)
            Spacer()
            Text("\(String(format: "%.2f", self.price)) ₺")
                .poppins(.regular, 12)
                .foregroundColor(Color.grayTextColor)
        }
        .padding(4)
        .background(self.color.cornerRadius(2))
        .padding(.horizontal, 6)
    }
}

//struct PriceCell_Previews: PreviewProvider {
//    static var previews: some View {
//
//
//        PriceCell(color: Color.blue.opacity(0.3), shopName: "A101", price: 7.48456)
//    }
//}
