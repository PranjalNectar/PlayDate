//
//  CurrentLocation.swift
//  PlayDate
//
//  Created by Pranjal on 25/05/21.
//


import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?
    private let geocoder = CLGeocoder()

    @Published var placemark: CLPlacemark? {
        willSet { objectWillChange.send() }
      }
    
    @Published var location: CLLocation? {
        willSet { objectWillChange.send() }
      }
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
              locationManager.distanceFilter = kCLDistanceFilterNone
              locationManager.requestAlwaysAuthorization()
              locationManager.startUpdatingLocation()
              locationManager.delegate = self
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

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        print(#function, statusString)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        print(#function, location)
        self.geocode()
    }
    
    private func geocode() {
        guard let location = self.lastLocation else { return }
        geocoder.reverseGeocodeLocation(location, completionHandler: { (places, error) in
          if error == nil {
            //print(places?[0])
            self.placemark = places?[0]
          } else {
            self.placemark = nil
          }
        })
      }
}


//{
//    City = Mumbai;
//    Country = India;
//    CountryCode = IN;
//    FormattedAddressLines =     (
//        "B1, Road Number 19",
//        "Wadala West",
//        "Mumbai, 400031",
//        Maharashtra,
//        India
//    );
//    Name = "B1, Road Number 19";
//    State = MH;
//    Street = "B1, Road Number 19";
//    SubAdministrativeArea = Mumbai;
//    SubLocality = "Wadala West";
//    SubThoroughfare = B1;
//    Thoroughfare = "Road Number 19";
//    ZIP = 400031;
//}


// Location name
//              if let locationName = placeMark.location {
//                  print(locationName)
//              }
//              // Street address
//              if let street = placeMark.thoroughfare {
//                  print(street)
//              }
//              // City
//              if let city = placeMark.subAdministrativeArea {
//                  print(city)
//              }
//              // Zip code
//              if let zip = placeMark.isoCountryCode {
//                  print(zip)
//              }
//              // Country
//              if let country = placeMark.country {
//                  print(country)
//              }
