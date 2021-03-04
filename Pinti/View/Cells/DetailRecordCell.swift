//
//  DetailProductCell.swift
//  Pinti
//
//  Created by Emin on 27.12.2020.
//

import SwiftUI
import CoreLocation
import MapKit
struct DetailRecordCell: View {
    @EnvironmentObject var categoriesAndShops: CategoriesAndShops
    var record: Record
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if let shopName = self.categoriesAndShops.findShopName(by: record.shopId ?? "") {
                    Text(shopName)
                        .poppins(.bold, 20)
                        .foregroundColor(Color.grayTextColor)

                }
                
                
                if let loc = record.locationTitle {
                    Text(loc)
                        .poppins(.regular, 14)
                        .foregroundColor(Color.grayTextColor)

                }
                HStack {
                    if let recordDate = record.recordDate {
                        
                        Text(recordDate)
                            .poppins(.italic, 12)
                            .foregroundColor(Color.grayTextColor.opacity(0.8))
                    }
                    if let ownerName = record.ownerName {
                        Text(ownerName)
                            .poppins(.italic, 12)
                            .foregroundColor(Color.pintiOrange)
                    }
                    
                }
                
               
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 0) {
                Text("\(String(format: "%.2f", record.price ?? 0)) ₺")
                    .poppins(.bold, 24)
                    .foregroundColor(Color.grayTextColor)
                
                
                Button(action: {
                    
                    guard let lat = Double(self.record.locationCoordinate?.split(separator: ",").first ?? ""),
                          let long = Double(self.record.locationCoordinate?.split(separator: ",").last ?? "") else { return }

                    let latitude: CLLocationDegrees = lat
                    let longitude: CLLocationDegrees = long
                    
                    let regionDistance:CLLocationDistance = 10000
                    let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
                    let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
                    let options = [
                        MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                        MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
                    ]
                    let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                    let mapItem = MKMapItem(placemark: placemark)
                    mapItem.name = self.categoriesAndShops.findShopName(by: self.record.shopId ?? "") ?? "Market"
                    mapItem.openInMaps(launchOptions: options)
                }, label: {
                    Image("mapspin")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.pintiOrange)
                        .scaledToFit()

                        .frame(height: 35, alignment: .center)
                })

                
            }
        }.padding()
        .background(Color.white.cornerRadius(6))
        .padding(.horizontal, 8)
    }
}

struct DetailProductCell_Previews: PreviewProvider {
    static var previews: some View {
        DetailRecordCell(record: Record(barcode: "1212", price: 12.1, recordDate: "12.12.2020", shopId: "1", locationCoordinate: "37.456,65.3456", locationTitle: "toros mh", ownerId: "1", ownerName: "Emin Özkalaycı")).environmentObject(CategoriesAndShops())
    }
}
