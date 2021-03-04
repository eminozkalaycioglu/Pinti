//
//  LocationManager.swift
//  Pinti
//
//  Created by Emin on 3.01.2021.
//

import Foundation
import CoreLocation
import Combine
class LocationManager: NSObject, ObservableObject {
    
    private let locationManager = CLLocationManager()
    @Published var address: String?
    

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        //todo bir kere çek
        print("emintest: loc init")
    }

    var locationStatus: CLAuthorizationStatus?

    var lastLocation: CLLocation?
    var locationString: String {
        if let lat = lastLocation?.coordinate.latitude.description, let lon = lastLocation?.coordinate.longitude.description {
            let str = "\(lat),\(lon)"
            return str
        }
        
        return "0,0"
        
    }
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }

        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }

    }

    
    func findAddress(lat: CLLocationDegrees, lon: CLLocationSpeed) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: lon)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error -> Void in
            
            
            // Place details
            guard let placeMark = placemarks?.first else { return }
            // Location name
           var address = ""
            // Street address
            if let street = placeMark.thoroughfare {
                address += street + ", "
                print(street)
            }
            // County
            if let county = placeMark.subAdministrativeArea {
                address += county + ", "
                print(county)
            }
            
            if let city = placeMark.administrativeArea {
                address += city
                print(city)
            }
            self.address = address
            
        })
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationStatus = status
        print(#function, statusString)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.lastLocation = location
        self.findAddress(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        print(#function, location)
    }

}
